{ pkgs, config, ... }:
{
  boot = {
    ######### Kernel
            ######### Bootloader
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    
    ######### initrd
    plymouth.enable = true;
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
    };
  };
}
