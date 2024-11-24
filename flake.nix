{
  description = "nyx";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/";
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

  outputs =
    inputs@{
      home-manager,
      hyprland,
      nixpkgs,
      nixpkgs-stable,
      nix-index-db,
      self,
      sops-nix,
      stylix,
      ...
    }:
    let
      stateVersion = "24.11";
      shellPlatforms = [ "x86_64-linux" ];
      nixosMachines = [
        "kdes"
        "klap"
      ];
      creds = import ./credentials;

      mkNixosSpec =
        hostName:
        nixpkgs.lib.nixosSystem rec {
          specialArgs = {
            inherit
              inputs
              self
              hyprland
              stateVersion
              hostName
              creds
              ;
          };
          modules = [
            ./pkg
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
                sharedModules = [ sops-nix.homeManagerModules.sops ];
              };
            }
            # Makes stable nixpkgs available as pkgs.stable
            (
              { config, ... }:
              {
                nixpkgs.overlays = [
                  (
                    post: prev: with config.nixpkgs; {
                      stable = import nixpkgs-stable {
                        inherit hostPlatform;
                        system = hostPlatform;
                        config.allowUnfree = config.allowUnfree;
                      };
                    }
                  )
                ];
              }
            )
          ];
        };

      mkShellSpec =
        hostPlatform:
        let
          pkgs = import nixpkgs {
            inherit hostPlatform;
            system = hostPlatform;
            config.allowUnfree = true;
          };
        in
        {
          default = pkgs.mkShell {
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
        };
    in
    with nixpkgs.lib;
    {
      nixosConfigurations = genAttrs nixosMachines mkNixosSpec;
      devShells = genAttrs shellPlatforms mkShellSpec;
    };
}
