# Use `config.lib.stylix.colors` to reference Stylix colors in other configs.
# This prevents type errors when using predefined color schemes.
# https://github.com/danth/stylix/issues/502#issuecomment-2308770449
{
  assetsPath,
  config,
  inputs,
  pkgs,
  ...
}: with pkgs; 
let
  # https://github.com/tinted-theming/schemes/tree/spec-0.11/base16
  # Use any theme from link without `.yaml`.
  theme = name: builtins.toPath "${base16-schemes}/share/themes/${name}.yaml";

  # Theme ideas:
  # - catpuccin-mocha
  # - ayu-mirage
  # - atelier-cave
  # - rose-pine
  # - tokyo-night-moon
  # - spaceduck
in {
  imports = [ inputs.stylix.nixosModules.stylix ];
  config = {
    stylix = {
      image = "${assetsPath}/wallpaper/mountains.png";
      base16Scheme = theme "ayu-mirage"; 
      enable = true;
      polarity = "dark";
      opacity.terminal = 0.8;
      cursor = {
        package = bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      fonts = {
        serif = config.stylix.fonts.sansSerif;
        sansSerif = {
          package = montserrat;
          name = "Montserrat";
        };
        monospace = {
          package = nyx-berkeley-mono;
          name = "BerkeleyMono Nerd Font";
        };
        emoji = {
          package = noto-fonts-emoji-blob-bin;
          name = "Blobmoji";
        };
      };
    };
  };
}
