{
  description = "nyx";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    stylix = {
      url = "github:danth/stylix";
    };
    fine-cmdline = {
      url = "github:VonHeikemen/fine-cmdline.nvim";
      flake = false;
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      flakeRoot = ./.;

      stateVersion = "24.05";
      hosts = [ "klap" "kdes" ];

      user = "kjkent";
      email = "kris@kjkent.dev";
      gitId = "Kristopher James Kent (kjkent)";
      # gpg/ssh fingerprint/keygrip/key should all refer to same GPG key.
      gpgFingerprint = "F0954AC5C9A90C70794CCA88B02F66B6C1A75107";
      gpgKeygrip = "22638115B2A44BACFCC08B658945BB46BC925523";
      sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVd7FB3ohh9ZJ9HWhDbYe0yPHxggkrELqPGxsXwDo6W openpgp:0x323C7F61";

      mkHost = host: nixpkgs.lib.nixosSystem rec {
        specialArgs = {
          inherit flakeRoot;
          inherit inputs;
          inherit stateVersion;
          inherit host;
          inherit user email gpgFingerprint gpgKeygrip sshKey gitId;
        };
        modules = [
          ./nixos             # State version, caching, GC
          ./host              # OS, package, & shared HW
          ./host/${host}.nix  # Machine-specific, e.g., CPU, GPU
          ./user              # User params

          home-manager.nixosModules.home-manager {
            home-manager = {
              users.${user} = import ./user/home-manager.nix;
              extraSpecialArgs = specialArgs;

              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
            };
          }

          inputs.stylix.nixosModules.stylix
        ];
      };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkHost;
    };
}
