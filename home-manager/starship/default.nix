{ config, ... }:
{
  config = {
    programs = {
      starship = {
        enable = true;
        add_newline = false;
        enableTransience = true;
        settings = {
          command_timeout = 1000;
          palettes = {
            stylix = with config.stylix.base16Scheme; {
              inherit
                base00 base01 base02 base03
                base04 base05 base06 base07
                base08 base09 base0A base0B
                base0C base0D base0E base0F;
            };
          } // 
            import ./theme-lava.nix { inherit config; };
        };
      };
    };
  };
}
