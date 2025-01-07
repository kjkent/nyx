{
  # Inputs should follow nixpkgs used for nixos.
  # inputs cannot use variables, because nix
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland.url = "github:hyprwm/hyprland";
    sops-nix.url = "github:mic92/sops-nix";
    stylix.url = "github:danth/stylix";
    vscode-exts.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = inputs @ {self, ...}: let
    nixpkgs = inputs.nixpkgs-unstable;
    assetsPath = ./assets;
    hmModulesPath = ./hm;
    nixosModulesPath = ./nixos;
    shellPlatforms = ["x86_64-linux"];

    nixosUser = import ./deploy/user.nix;

    # hostnames enumerated from dir names within ./deploy/hosts
    # "shared" is ignored, for shared config.
    nixosHosts =
      builtins.attrNames (     # return attribute names...
      (nixpkgs.lib.filterAttrs # ...of attrset from filtering for...
      (k: v: v == "directory" && k != "shared") # ...directories not named "shared"...
      (builtins.readDir ./deploy/hosts))); # ...from listing files/dirs in ./deploy/hosts

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
          ./nixos
          ./pkg
          ./deploy/hosts/${hostName}
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
    with nixpkgs.lib; {
      nixosConfigurations = genAttrs nixosHosts mkNixosSpec;
      devShells = genAttrs shellPlatforms mkShellSpec;
    };
}
