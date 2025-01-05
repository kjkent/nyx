{pkgs, ...}: {
  config = {
    gtk = {
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    home.packages = with pkgs; [
      hyprpaper
    ];
    qt = {
      enable = true;
      style.name = "adwaita-dark";
      platformTheme.name = "gtk3";
    };
    stylix.enable = true; # Stylix configured in NixOS module
  };
}
