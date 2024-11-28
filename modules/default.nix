{
  home-manager,
  hostName,
  nix-index-db,
  self,
  sops-nix,
  stylix,
  ...
}:
{
  imports = [
    home-manager.nixosModules.home-manager
    nix-index-db.nixosModules.nix-index
    sops-nix.nixosModules.sops
    stylix.nixosModules.stylix

    "${self}/pkg"
    ./nixos
    (import "${self}/deploy/hosts.nix")."${hostName}"
  ];
}
