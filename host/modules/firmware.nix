{ ... }: 
{
  config = {
    hardware = {
      enableAllFirmware = true; # Provides linux-firmware
      cpu.intel.updateMicrocode = true;
      cpu.amd.updateMicrocode = true;
    };
    services.fwupd.enable = true; # Provides fwupdmgr
  };
}