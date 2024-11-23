{ lib, config, ... }:
with lib;
let
  cfg = config.vm.guest-services;
in
{
  options.vm.guest-services = {
    enable = mkEnableOption "Whether to enable virtual machine guest services";
  };

  config = mkIf cfg.enable {
    services = {
      spice-vdagentd.enable = true;
      spice-webdavd.enable = true;
      qemuGuest.enable = true;
    };
  };
}
