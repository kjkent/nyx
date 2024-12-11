{
  assetsPath,
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  config = {
    stylix = with pkgs; {
      image = "${assetsPath}/wallpaper/mountains.png";
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
