{
  lib,
  pkgs,
  user,
  config,
  ...
}:
{
  options =
    with lib;
    with types;
    {
      nyx = {
        shell = mkOption {
          type = enum [
            "bash"
            "fish"
            "zsh"
          ];
          default = "zsh";
        };
        terminal = mkOption {
          type = str;
          default = "foot";
        };
        browser = mkOption {
          type = str;
          default = "firefox";
        };
      };
    };
  config = with config.nyx; {
    users.users.${user}.shell = pkgs.${shell};
  };
}
