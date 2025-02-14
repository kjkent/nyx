{config, lib, pkgs, ...}: {
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
      duf
      ncdu
      ripgrep
      file-roller
      rsync
      tree
      wget
      eza
      zlib-ng
    ];
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/nyx_root";
        fsType = "xfs";
      };
      "/boot" = lib.mkIf (!config.boot.isBios) {
        device = "/dev/disk/by-label/nyx_boot";
        fsType = "vfat";
        options = [
          "rw"
          "relatime"
          "umask=0077"
          "codepage=437"
          "iocharset=iso8859-1"
          "shortname=mixed"
          "utf8"
          "errors=remount-ro"
        ];
      };
    };
    boot.initrd.luks.devices.nyx_root.device = "/dev/disk/by-label/nyx_crypt";
    services = {
      gvfs.enable = true;
      smartd.enable = false;
      fstrim.enable = true; # Periodic SSD trimming
    };
  };
}
