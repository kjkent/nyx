{ hostName, nixosModulesPath, self, ... }: let
  customPkgs = "${self}/pkg";
  hostVariations = (import "${self}/deploy/hosts.nix")."${hostName}";
in {
  # Home Manager modules are imported by its NixOS module
  imports = [nixosModulesPath customPkgs hostVariations];
}
