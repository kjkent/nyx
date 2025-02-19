# Use `config.lib.stylix.colors` to reference Stylix colors in other configs.
# This prevents type errors when using predefined color schemes.
# https://github.com/danth/stylix/issues/502#issuecomment-2308770449
{
  assetsPath,
  config,
  inputs,
  pkgs,
  ...
}:
with pkgs; let
  # https://github.com/tinted-theming/schemes/tree/spec-0.11/base16
  # Use any theme from link without `.yaml`.
  palette = theme: "${base16-schemes}/share/themes/${theme}.yaml";
  # Theme ideas:
  # - catpuccin-mocha
  # - ayu-mirage
  # - atelier-cave
  # - rose-pine
  # - tokyo-night-moon
  # - spaceduck
in {
  imports = [inputs.stylix.nixosModules.stylix];
  config = {
    stylix = {
      image = "${assetsPath}/wallpaper/mountains.png";
      base16Scheme = palette "spaceduck";
      enable = true;
      polarity = "dark";
      opacity.terminal = 0.8;
      cursor = {
        package = bibata-modern-rainbow;
        name = "Bibata-Modern-Rainbow";
        size = 24;
      };
      fonts = rec {
        emoji = {
          package = noto-fonts-emoji-blob-bin;
          name = "Blobmoji";
        };
        monospace = {
          package = berkeley-mono;
          name = "Berkeley Mono";
        };
        sansSerif = {
          package = montserrat;
          name = "Montserrat";
        };
        serif = sansSerif;
      };
    };
  };
}
