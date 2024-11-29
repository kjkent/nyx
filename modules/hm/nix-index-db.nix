{ inputs, ... }:
{
  imports = [ inputs.nix-index-db.hmModules.nix-index ];
  config = {
    programs = {
      nix-index-database.comma.enable = true;
      nix-index.enable = true; # `command-not-found` functionality
    };
  };
}
