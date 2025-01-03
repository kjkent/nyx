{
  config,
  lib,
  nixosUser,
  self,
  ...
}: {
  config = {
    # Links repo to /etc/self for an always current view of the present config
    # https://www.reddit.com/r/NixOS/comments/1amj6qm/comment/kpro1wm/
    environment.etc.self.source = self;

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

    system = {
      # Adds git commit to generation label
      # https://www.reddit.com/r/NixOS/comments/1amj6qm/comment/kppoogf/
      nixos.label = lib.concatStringsSep "-" (
        (lib.sort (x: y: x < y) config.system.nixos.tags)
        ++ ["${config.system.nixos.version}.${self.sourceInfo.shortRev or "UNCLEAN"}"]
      );
    };

    programs = {
      nix-ld = {
        enable = true;
        # libraries = [ ]; # Put extra library packages here if needed
      };
    };
  };
}
