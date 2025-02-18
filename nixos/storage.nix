{config, lib, nixosUser, pkgs, ...}: {
  config = let
    ## partition names:
    # bios_boot likely unused on GPT disks as GRUB installed in space before partition 1
    boot = (if config.boot.isBios then "bios" else "esp") + "_boot";
    cryptSuffix = "_crypt";
    home = "${nixosUser.username}_home";
    root = "nyx_root";
  in {
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
      "/home/${nixosUser.username}" = {
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
