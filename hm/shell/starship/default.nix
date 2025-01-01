{config, ...}: let
  theme = ./theme-lava.nix;
in {
  config = {
    programs = {
      starship = {
        enable = true;
        enableTransience = true;
        settings =
          {
            add_newline = false;
            command_timeout = 1000;
          }
          // (import theme {inherit config;});
      };
    };
  };
}
