{ ... }:
{
  config = {
    services = {
      libinput.enable = true;
      gvfs.enable = true;
    };
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
