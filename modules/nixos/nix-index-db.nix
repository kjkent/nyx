{ inputs, lib, ... }:
{
  imports = [ inputs.nix-index-db.nixosModules.nix-index ];
  config = {
    programs = {
      nix-index-database.comma.enable = true;
      command-not-found.enable = lib.mkForce false;
    };
  };
}
