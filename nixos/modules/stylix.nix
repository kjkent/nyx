{
  pkgs,
  config,
  self,
  ...
}:
{
  config = {
    stylix = with pkgs; {
      enable = true;
      image = self + "/assets/cyberpunk.jpg";
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
          package = nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
          name = "JetBrainsMono Nerd Font Mono";
        };
        emoji = {
          package = noto-fonts-emoji-blob-bin;
          name = "Blobmoji";
        };
      };
    };
  };
}