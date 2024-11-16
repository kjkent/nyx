{
  description = "nyx";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fine-cmdline = {
      url = "github:VonHeikemen/fine-cmdline.nvim";
      flake = false;
    };
  };

  outputs =
    inputs@{
    self,
    nixpkgs,
    home-manager,
    hyprland,
    stylix,
    flake-utils,
    ...
    }:
    let
      stateVersion = "24.11";
      hosts = [ "klap" "kdes" ];
      trustedNetwork = "winstan.lan"; # TODO: Change this option

      user = "kjkent";
      email = "kris@kjkent.dev";
      gitId = "Kristopher James Kent (kjkent)";
      # gpg/ssh fingerprint/keygrip/key should all refer to same GPG key.
      gpgFingerprint = "F0954AC5C9A90C70794CCA88B02F66B6C1A75107";
      gpgKeygrip = "22638115B2A44BACFCC08B658945BB46BC925523";
      sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVd7FB3ohh9ZJ9HWhDbYe0yPHxggkrELqPGxsXwDo6W openpgp:0x323C7F61";

      mkHost = host: nixpkgs.lib.nixosSystem rec {
        specialArgs = {
          inherit
          inputs 
          self 
          hyprland
          stateVersion
          host
          user
          email
          gpgFingerprint
          gpgKeygrip
          sshKey
          gitId
          trustedNetwork
          ;
        };
        modules = [
          ./nixos
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.${user} = import ./home-manager;
              extraSpecialArgs = specialArgs;
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
            };
          }
        ];
      };
      # Development shell configuration
      devShell =
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
          pkgs.mkShell {
            name = "nyx-dev";

            nativeBuildInputs = with pkgs; [
              # Nix tools
              nixd # Nix language server
              nixfmt-rfc-style # Nix formatter
              statix # Nix static analysis
              deadnix # Find dead Nix code
              alejandra # Alternative Nix formatter

              # Git tools
              git
              git-crypt # Encryption for git repositories

              # Additional utilities
              just # Command runner
            ];

            shellHook = ''
            echo "Welcome to the nyx development environment!"
            echo "Available tools:"
            echo "  - nixd: Nix language server"
            echo "  - nixfmt-unstable: Nix formatter"
            echo "  - statix: Static analysis for Nix"
            echo "  - deadnix: Find dead Nix code"
            echo "  - git-crypt: Encryption for git repositories"
            echo "  - just: Command runner"
            echo "  - alejandra: Alternative Nix formatter"
            '';
          };
    in
      {
        nixosConfigurations = nixpkgs.lib.genAttrs hosts mkHost;
      }
    // flake-utils.lib.eachDefaultSystem (system: {
      devShells.default = devShell system;
    });
}
