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
        # Optimise new store contents - `nix-store optimise` cleans old
        auto-optimise-store = true;
        use-xdg-base-directories = true;
        download-buffer-size = 536870912; # 512MB
        # https://bmcgee.ie/posts/2023/12/til-how-to-optimise-substitutions-in-nix/
        http-connections = 128;
        max-substitution-jobs = 128;
        max-jobs = "auto";
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://hyprland.cachix.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        trusted-users = ["${nixosUser.username}"];
      };
    };

    nixpkgs = {
      overlays = with inputs; let 
        initPkgs = namespace: pkgs: (post: pre:
          with config.nixpkgs; {
            ${namespace} = import pkgs {
              inherit (pre.hostPlatform) system;
              inherit (config) allowUnfree;
            };
          }
        );
      in [
        # Makes nixpkgs revisions/branches available as string val
        (initPkgs "stable" nixpkgs-stable)
        (initPkgs "unstable" nixpkgs-unstable)

        # pkgs.{{vscode-marketplace,open-vsx}{,-release},forVSCodeVersion "<ver>"}
        # overlay checks for compatibility anyway (I think)
        inputs.vscode-exts.overlays.default

        # nixos-rebuild ignores tmpdir set (elsewhere in file) to avoid OOS
        # during build when tmp on tmpfs. workaround is this overlay. see:
        # https://github.com/NixOS/nixpkgs/issues/293114#issuecomment-2381582141
        (final: prev: {
          nixos-rebuild = prev.nixos-rebuild.overrideAttrs (oldAttrs: {
            nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [prev.makeWrapper];
            postInstall = oldAttrs.postInstall + ''
              wrapProgram $out/bin/nixos-rebuild --set TMPDIR ${nixTmpDir}
            '';
          });
        })
      ];
      config.allowUnfree = true; # Only for build
      hostPlatform = lib.mkDefault "x86_64-linux";
    };

    system = {
      # Adds git commit to generation label
      # https://www.reddit.com/r/NixOS/comments/1amj6qm/comment/kppoogf/
      nixos.label = lib.concatStringsSep "-" (
        (lib.sort (x: y: x < y) config.system.nixos.tags)
        ++ ["${config.system.nixos.version}.${self.sourceInfo.shortRev or "UNCLEAN"}"]
      );
    };

    systemd = {
      # prevent OOS error during builds when using zram/tmp on tmpfs
      services.nix-daemon.environment.TMPDIR = nixTmpDir;
      tmpfiles.rules = [ "d ${nixTmpDir} 0755 root root 1d" ];
    };

    programs = {
      nix-ld = {
        enable = true;
        # libraries = [ ]; # Put extra library packages here if needed
      };
    };
  };
}
