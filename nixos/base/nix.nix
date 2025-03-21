{
  config,
  inputs,
  lib,
  nixosUser,
  self,
  ...
}: let
  # /var/tmp doesn't seem to be on tmpfs like /tmp (when using zram) but
  # seems to contain near duplicate systemd unit folders?...
  # dir must exist on a new system to avoid error as nixos-rebuild uses
  # mktemp -d and won't implicitly create parents
  nixTmpDir = "/var/tmp";
in {
  config = {
    # Links repo to /etc/self for an always current view of the present config
    # https://www.reddit.com/r/NixOS/comments/1amj6qm/comment/kpro1wm/
    environment = {
      etc.self.source = self;
      # Needed for post-install. allowUnfree in flake config only used for
      # flake install. Makes sense -__-.
      sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
    };

    nix = {
      channel.enable = false; # Unnecessary due to flake but enabled by default
      settings = {
        connect-timeout = 5;
        min-free = 1073741824; # 1 GiB
        fallback = true; # don't fail if remote builder unavailable
        # Optimise new store contents - `nix-store optimise` cleans old
        auto-optimise-store = true;
        use-xdg-base-directories = true;
        download-buffer-size = 536870912; # 512MiB
        # https://bmcgee.ie/posts/2023/12/til-how-to-optimise-substitutions-in-nix/
        http-connections = 128;
        max-jobs = 1;
        max-silent-time = 3600; # kills build after 1hr with no logging
        max-substitution-jobs = 128;
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        # cache.nixos.org included by default with priority 40
        substituters = [
          "https://hyprland.cachix.org?priority=41"
          "https://nix-community.cachix.org?priority=42"
          "https://numtide.cachix.org?priority=43"
          "https://cuda-maintainers.cachix.org?priority=44"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        ];
        trusted-users = ["${nixosUser.username}"];
      };
    };

    nixpkgs = {
      overlays = [
        (_post: _pre: {
          stable = import inputs.nixos-stable {
            inherit (config.nixpkgs.hostPlatform) system;
            config = {inherit (config.nixpkgs.config) allowUnfree;};
          };
        })

        # pkgs.{{vscode-marketplace,open-vsx}{,-release},forVSCodeVersion "<ver>"}
        # overlay checks for compatibility anyway (I think)
        inputs.vscode-exts.overlays.default

        # nixos-rebuild ignores tmpdir set (elsewhere in file) to avoid OOS
        # during build when tmp on tmpfs. workaround is this overlay. see:
        # https://github.com/NixOS/nixpkgs/issues/293114#issuecomment-2381582141
        (_final: prev: {
          nixos-rebuild = prev.nixos-rebuild.overrideAttrs (oldAttrs: {
            nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [prev.makeWrapper];
            postInstall =
              oldAttrs.postInstall
              + ''
                wrapProgram $out/bin/nixos-rebuild --set TMPDIR ${nixTmpDir}
              '';
          });
        })
      ];
      config.allowUnfree = true; # Only for build, set NIX_ALLOW_UNFREE for deployed use
      hostPlatform = lib.mkDefault {system = "x86_64-linux";};
    };

    systemd = {
      # prevent OOS error during builds when using zram/tmp on tmpfs
      services.nix-daemon.environment.TMPDIR = nixTmpDir;
      tmpfiles.rules = ["d ${nixTmpDir} 0755 root root 1d"];

      # OOM config (https://discourse.nixos.org/t/nix-build-ate-my-ram/35752)
      slices."nix-daemon".sliceConfig = {
        ManagedOOMMemoryPressure = "kill";
        ManagedOOMMemoryPressureLimit = "90%";
      };
      services."nix-daemon".serviceConfig = {
        Slice = "nix-daemon.slice";
        # If kernel OOM does occur, strongly prefer
        # killing nix-daemon child processes
        OOMScoreAdjust = 1000;
      };
    };

    programs = {
      nix-ld = {
        enable = true;
        # libraries = [ ]; # Put extra library packages here if needed
      };
    };
  };
}
