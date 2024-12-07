{ config, ... }:
{
  config = {
    boot = {
      kernelModules = [ "acpi_call" ];
      extraModulePackages = [ config.boot.kernelPackages.acpi_call ];
    };
    services = {
      tlp = {
        enable = true;
      };
      upower = {
        enable = true;
      };
    };
  };
}
