{ pkgs, ... }:
{
  config = {
    services = {
      ipp-usb.enable = false;
      printing = {
        enable = true;
        drivers = with pkgs; [
          brgenml1lpr
          brgenml1cupswrapper
        ];
      };
    };
    hardware.sane = {
      enable = true;
      extraBackends = with pkgs; [ sane-airscan ];
    };
  };
}
