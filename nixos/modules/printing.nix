{pkgs, ...}: {
  config = {
    services = {
      ipp-usb.enable = false;
      printing = {
        enable = false;
        drivers = [];
      };
    };
    hardware.sane = {
      enable = false;
      extraBackends = [pkgs.sane-airscan];
    };
  };
}
