{ ... }:
{
  config = {
    zramSwap.enable = true;
    swapDevices = [ ];
    boot = {
      kernel.sysctl = {
        "vm.swappiness" = 180;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.page-cluster" = 0;
      };
      tmp = {
        useTmpfs = true;
        tmpfsSize = "30%";
      };
      initrd.luks.devices.root = {
        crypttabExtraOpts = [ "fido2-device=auto" ];
      };
    };
    services = {
      # S.M.A.R.T
      smartd = {
        enable = false;
        autodetect = true;
      };
      # Periodic SSD trimming
      fstrim.enable = true;
    };
  };
}
