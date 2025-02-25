{
  config,
  lib,
  ...
}: {
  options = {
    hardware.laptop.powerManagement.enable = with lib;
      mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable laptop power management";
      };
  };
  config = lib.mkIf config.hardware.laptop.powerManagement.enable {
    boot = {
      kernelModules = ["acpi_call"];
      extraModulePackages = [config.boot.kernelPackages.acpi_call];
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
