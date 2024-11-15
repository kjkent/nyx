{
  config,
  lib,
  stateVersion,
  self,
  ...
}:
{
  imports = [
    ./host.nix
    ./user.nix
  ];

  config = {
    # Copies this repo to /etc for an always current view of
    #  the present config.
    # https://www.reddit.com/r/NixOS/comments/1amj6qm/comment/kpro1wm/
    environment.etc.self.source = self;

    # no-op when !nix.channel.enable hence env var
    # github.com/NixOS/nixpkgs/issues/356209
    nixpkgs.config.allowUnfree = true;
    environment.sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
    };
    nix = {
      channel.enable = false; # Unnecessary due to flake but enabled by default
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      settings = {
        # Optimise new store contents - `nix-store optimise` cleans old
        auto-optimise-store = true;
        use-xdg-base-directories = true;
        http-connections = 128; # https://bmcgee.ie/posts/2023/12/til-how-to-optimise-substitutions-in-nix/#:~:text=cachix.org.-,Extra%20performance,-As%20I%20flailed
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
      };
    };

    system = {
      # Be careful of changing - check https://nixos.org/nixos/options.html
      inherit stateVersion;

      # Adds git commit to generation label
      # https://www.reddit.com/r/NixOS/comments/1amj6qm/comment/kppoogf/
      nixos.label = lib.concatStringsSep "-" (
        (lib.sort (x: y: x < y) config.system.nixos.tags)
        ++ [ "${config.system.nixos.version}.${self.sourceInfo.shortRev or "UNCLEAN"}" ]
      );

      # Forces a clean git tree so deployments are guaranteed to be committed.
      # To check flake: `NIX_IGNORE_UNCLEAN=1 nix flake check --impure`
      configurationRevision =
        if builtins.getEnv "NIX_IGNORE_UNCLEAN" == "1" then
          "UNCLEAN"
        else self.rev or (throw "Uncommitted changes; exiting...");
    };
  };
}
