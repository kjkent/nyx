{ flakeRoot, pkgs, ... }:
{
  config = {
    stylix = {
      enable = true;
      image = "${flakeRoot}/user/home/wallpapers/beautifulmountainscape.jpg";
      polarity = "dark";
      opacity.terminal = 0.8;
      cursor.package = pkgs.bibata-cursors;
      cursor.name = "Bibata-Modern-Ice";
      cursor.size = 24;
      fonts = {
        monospace = {
          package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
          name = "JetBrainsMono Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.montserrat;
          name = "Montserrat";
        };
        serif = {
          package = pkgs.montserrat;
          name = "Montserrat";
        };
        sizes = {
          applications = 12;
          terminal = 12;
          desktop = 12;
          popups = 12;
        };
      };
    };
  };
}
