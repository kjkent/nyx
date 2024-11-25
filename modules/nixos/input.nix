{ pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      cameractrls
      pavucontrol
    ];

    hardware = {
      logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    };

    services = {
      blueman.enable = true;
      gvfs.enable = true;
      libinput.enable = true;
    };
  };
}
