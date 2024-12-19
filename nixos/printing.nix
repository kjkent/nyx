{ nixosUser, pkgs, ... }:
{
  config = {
    hardware.sane = {
      enable = true;
      extraBackends = with pkgs; [ sane-airscan ];
    };

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

    users.users.${nixosUser.username}.extraGroups = [ "lp" "scanner" ];
  };
}
