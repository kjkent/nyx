{ config, inputs, lib, stateVersion, ... }:
{
  config = {
    ### Copies nixpkgs and this repo to /etc for an always current view of
    ###  the present config.
    # https://www.reddit.com/r/NixOS/comments/1amj6qm/comment/kpro1wm/
    environment.etc."self/nixpkgs".source = inputs.nixpkgs;
    environment.etc."self/flake".source = inputs.self;

    nix = {
      settings = {
        # Optimise new store contents - `nix-store optimise` cleans old
        auto-optimise-store = true;
        use-xdg-base-directories = true;
        http-connections = 128;  # https://bmcgee.ie/posts/2023/12/til-how-to-optimise-substitutions-in-nix/#:~:text=cachix.org.-,Extra%20performance,-As%20I%20flailed
        max-substitution-jobs = 128;
        max-jobs = "auto";
        experimental-features = [ "nix-command" "flakes" ];
        substituters = [ 
          "https://hyprland.cachix.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [ 
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
    nixpkgs.config.allowUnfree = true;
    
    system = {
      # Be careful of changing - check https://nixos.org/nixos/options.html
      stateVersion = stateVersion;

      ### Adds git commit to generation label
      # https://www.reddit.com/r/NixOS/comments/1amj6qm/comment/kppoogf/
      nixos.label = lib.concatStringsSep "-" (
        (lib.sort (x: y: x < y) config.system.nixos.tags)
        ++ [ "${config.system.nixos.version}.${inputs.self.sourceInfo.shortRev or "dirty"}" ]
      );
    };
  };
}
