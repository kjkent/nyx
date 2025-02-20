{config, lib, ...}: {
  options = with lib; {
    boot.isBios = mkOption {
      type = types.bool;
      default = false;
      description = "Whether system is BIOS-only (ie., not UEFI)";
    };
  };
  config = {
    boot = {
      loader = {
        grub = lib.mkIf config.boot.isBios {
	  enable = true;
	  enableCryptodisk = true;
          device = "/dev/nvme0n1";
	  useOSProber = false;
	};
        systemd-boot = lib.mkIf (!config.boot.isBios) {
          enable = true;
          consoleMode = "max";
          edk2-uefi-shell.enable = true;
          memtest86.enable = true;
          rebootForBitlocker = true;
        };
        efi.canTouchEfiVariables = true;
        timeout = 0;
      };

      plymouth.enable = true;
      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "nvme"
          "usb_storage"
          "sd_mod"
        ];
      };
    };
  };
}
