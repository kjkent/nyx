{ config, inputs, lib, stateVersion, ... }:
{
  config = {
    ### Copies nixpkgs and this repo to /etc for an always current view of
    ###  the present config.
    # https://www.reddit.com/r/NixOS/comments/1amj6qm/comment/kpro1wm/
    environment.etc.nixpkgs.source = inputs.nixpkgs;
    environment.etc.self.source = inputs.self;

    nix = {
      settings = {
        auto-optimise-store = true;
        use-xdg-base-directories = true;
        experimental-features = [ "nix-command" "flakes" ];
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
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
