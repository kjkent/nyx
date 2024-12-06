{
  description = "nyx";

  # Inputs should follow nixpkgs used for nixosSystem 
  inputs = {
    nixpkgs-master.url = "github:nixos/nixpkgs"; # master branch ("extra unstable")
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager"; # main branch for nixpkgs-unstable, else release-yy.mm
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    stylix = {
      url = "github:danth/stylix"; # main branch for nixpkgs-unstable, else release-yy.mm
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    systems.url = "github:nix-systems/default"; # req by nix-auto-follow
  };

  outputs =
    inputs@{
      home-manager,
      nixpkgs-stable,
      nixpkgs-unstable,
      self,
      ...
    }:
    let
      assetsPath = ./assets;
      hmModulesPath = ./modules/hm;
      shellPlatforms = [ "x86_64-linux" ];

      nixosUser = import ./deploy/user.nix;
      nixosHosts = builtins.attrNames (import ./deploy/hosts.nix);

      mkNixosSpec =
        hostName:
        nixpkgs-unstable.lib.nixosSystem {
          specialArgs = {
            inherit
              assetsPath
              hmModulesPath
              home-manager
              hostName
              inputs
              nixosUser
              self
              ;
          };
          modules = [ ./modules ];
        };

      mkShellSpec =
        hostPlatform:
        let
          pkgs = import nixpkgs-stable {
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
    with nixpkgs-stable.lib;
    {
      nixosConfigurations = genAttrs nixosHosts mkNixosSpec;
      devShells = genAttrs shellPlatforms mkShellSpec;
    };
}
