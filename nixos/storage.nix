{config, lib, nixosUser, pkgs, ...}: {
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
    fileSystems = let
      boot = "nyx_boot";
      cryptSuffix = "_crypt";
      home = "${nixosUser}_home";
      root = "nyx_root";
    in {
      "/" = {
        device = "/dev/disk/by-label/${root}";
        fsType = "xfs";
      };
      "/boot" = lib.mkIf (!config.boot.isBios) {
        device = "/dev/disk/by-label/${boot}";
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
      "/home" = {
        device = "/dev/disk/by-label/${home}";
        fsType = "xfs";
      };
    };
    boot.initrd.luks.devices = {
      "${home}".device = "/dev/disk/by-label/${home}${cryptSuffix}";
      "${root}".device = "/dev/disk/by-label/${root}${cryptSuffix}";
    };
    services = {
      gvfs.enable = true;
      smartd.enable = false;
      fstrim.enable = true; # Periodic SSD trimming
    };
  };
}
