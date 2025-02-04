{
  # Inputs should follow nixpkgs used for nixos.
  # inputs cannot use variables, because nix
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    hyprland.url = "github:hyprwm/hyprland/v0.47.1-b";
    sops-nix.url = "github:mic92/sops-nix";
    stylix.url = "github:danth/stylix/release-24.11";
    vscode-exts.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = inputs @ {self, ...}: let
    nixpkgs = inputs.nixpkgs-stable;
    assetsPath = ./assets;
    hmModulesPath = ./hm;
    nixosModulesPath = ./nixos;
    shellPlatforms = ["x86_64-linux"];
    nixosUser = import ./user;

    # hostnames enumerated from dir names within hosts/
    # "shared" is ignored, for shared config.
    nixosHosts = builtins.attrNames (nixpkgs.lib.filterAttrs # ...of attrset from filtering for...
      
      (k: v: v == "directory" && k != "shared") # ...directories not named "shared"...
      
      (builtins.readDir ./hosts)); # ...from listing files/dirs in hosts/

    mkNixosSpec = hostName:
      nixpkgs.lib.nixosSystem {
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
          ./hosts/${hostName}
          ./nixos
          ./pkg
          ./sops
        ];
      };

    mkShellSpec = system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          # Nix tools
          nixd # Nix language server
          statix # Nix static analysis
          deadnix # Find dead Nix code
          alejandra # Nix formatter

          # Git tools
          git
          git-crypt # Encryption for git repositories
        ];

        shellHook = ''
          echo "Welcome to the nyx development environment!"
          echo "Available tools:"
          echo "  - alejandra: Nix formatter"
          echo "  - deadnix: Find dead Nix code"
          echo "  - git-crypt: Encryption for git repositories"
          echo "  - nixd: Nix language server"
          echo "  - statix: Static analysis for Nix"
        '';
      };
    };
  in
    with nixpkgs.lib; {
      nixosConfigurations = genAttrs nixosHosts mkNixosSpec;
      devShells = genAttrs shellPlatforms mkShellSpec;
    };
}
