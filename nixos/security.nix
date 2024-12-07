{ pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      git-crypt
      pam_u2f
      sops
      tpm2-tss
      tpm2-tools
      yubikey-manager
    ];
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
    hardware.gpgSmartcards.enable = true; # Adds udev rules only
    security = {
      rtkit.enable = true; # Allows processes to get scheduling priority
      pam.services.hyprlock = { }; # Required by HM hyprlock module
    };
  };
}
