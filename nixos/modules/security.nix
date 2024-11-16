_: {
  config = {
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
    hardware.gpgSmartcards.enable = true; # Adds udev rules only
    security = {
      rtkit.enable = true; # Allows processes to get scheduling priority
      pam.services.hyprlock = {}; # Required by HM hyprlock module
    };
  };
}
