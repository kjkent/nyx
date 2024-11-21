{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      # Compression & filesystem
      parted
      gptfdisk
      gnutar
      gzip
      unzip
      unrar
      xfsprogs
      xz
      # File utils
      file-roller
      rsync
      tree
      wget
      eza
    ];
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/nyx_root";
        fsType = "xfs";
      };
      "/boot" = {
        device = "/dev/disk/by-label/nyx_efi";
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
    swapDevices = [];
    boot = {
      initrd.luks.devices.nyx_root.device = "/dev/disk/by-label/nyx_luks";
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
    };
    services = {
      # S.M.A.R.T
      smartd.enable = false;
      fstrim.enable = true; # Periodic SSD trimming
    };
  };
}
