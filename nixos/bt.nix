{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      overskride
    ];
    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
      logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };
    };
  }
}
