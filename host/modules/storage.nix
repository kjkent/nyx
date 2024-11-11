{ ... }:
{
  config = {
    fileSystems = {
      "/" = {
        fsType = "xfs";
      };
      "/boot" = {
        fsType = "vfat";
        options = [
          "rw"
          "relatime"
          "fmask=0022"
          "dmask=0022"
          "codepage=437"
          "iocharset=iso8859-1"
          "shortname=mixed"
          "utf8"
          "errors=remount-ro"
        ];
      };
    };
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
      smartd.enable = false;     
      fstrim.enable = true; # Periodic SSD trimming
    };
  };
}
