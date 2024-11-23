{
  description = "nyx";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/release-24.11"; # Change to /nixos-24.11 when updated
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11"; # release-24.11 is the 24.11 branch (no nixos-24.11)
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-db = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-utils,
    home-manager,
    hyprland,
    nix-index-db,
    nixpkgs,
    self,
    sops-nix,
    stylix,
    ...
    }: let
      stateVersion = "24.11";
      hosts = ["klap" "kdes"];
      creds = import ./credentials;

      mkHost = host: nixpkgs.lib.nixosSystem rec {
        specialArgs = {
          inherit
          inputs
          self
          hyprland
          stateVersion
          host
          creds
          ;
        };
        modules = [
          ./lib
          ./nixos
          sops-nix.nixosModules.sops
          nix-index-db.nixosModules.nix-index
          { programs.nix-index-database.comma.enable = true; }
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.${creds.username} = import ./home-manager;
              extraSpecialArgs = specialArgs;
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
              sharedModules = [
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };
      # Development shell configuration
      devShell = system: let
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
          echo "  - nixfmt: Nix formatter (RFC style)"
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
