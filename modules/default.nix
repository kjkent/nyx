{ hostName, self, ... }: let
  nixosModules = ./nixos;
  customPkgs = "${self}/pkg";
  hostVariations = (import "${self}/deploy/hosts.nix")."${hostName}";
in {
  # Home Manager modules are imported by its NixOS module
  imports = [nixosModules customPkgs hostVariations];
}
