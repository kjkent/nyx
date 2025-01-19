_: {
  config = {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          consoleMode = "max";
          edk2-uefi-shell.enable = true;
          memtest86.enable = true;
          rebootForBitlocker = true;
        };
        efi.canTouchEfiVariables = true;
      };
      timeout = 0;

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
