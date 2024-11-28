{nix-index-db, ...}: {
  imports = [nix-index-db.hmModules.nix-index];
  config = {
    programs.nix-index-database.comma.enable = true;
    programs.nix-index.enable = true; # `command-not-found` functionality
  };
}
