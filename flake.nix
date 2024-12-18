{
  description = "nyx";

  # Inputs should follow nixpkgs used for nixos.
  # `inputs` cannot use variables, because nix
  inputs = {
    nixpkgs-master.url = "github:nixos/nixpkgs"; # "extra unstable"
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
    vscode-exts = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # nix-auto-follow
    flake-utils.url = "github:numtide/flake-utils"; # stylix/vscode-exts
    systems.url = "github:nix-systems/default";
  };

outputs = inputs@{self, ...}:
    let
      nixpkgs = inputs.nixpkgs-unstable;

      assetsPath = ./assets;
      hmModulesPath = ./hm;
      nixosModulesPath = ./nixos;
      shellPlatforms = [ "x86_64-linux" ];

      nixosUser = import ./deploy/user.nix;
      nixosHosts = with nixpkgs.lib; pipe ./deploy/hosts [
        builtins.readDir
        (filterAttrs (name: _: hasSuffix ".nix" name))
        (mapAttrsToList (name: _: removeSuffix ".nix" name))
      ];

      mkNixosSpec = hostName: nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
          assetsPath
          hmModulesPath
          nixosModulesPath
          hostName
          inputs
          nixosUser
          self
          ;
        };
        modules = [ 
          ./nixos
          ./pkg 
          ./deploy/hosts/${hostName}.nix
        ];
      };

      mkShellSpec = system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
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
      nixosConfigurations = genAttrs nixosHosts mkNixosSpec;
      devShells = genAttrs shellPlatforms mkShellSpec;
    };
}
