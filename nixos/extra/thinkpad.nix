# UPDATE 01032025: Some sections commented out due to tpacpi issues with libreboot
{
  config,
  lib,
  ...
}: {
  options = {
    hardware.laptop.thinkpad.enable = with lib;
      mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable ThinkPad configuration";
      };
  };
  config = lib.mkIf config.hardware.laptop.thinkpad.enable {
    #boot.kernelParams = ["thinkpad_acpi.force_load=1"];
    hardware.trackpoint = {
      enable = true;
      emulateWheel = true;
    };
    #services = {
    #  throttled.enable = true;
    #  tp-auto-kbbl = {
    #    enable = true;
    #    device = "/dev/input/event1"; # `evtest` lists event devices
    #    arguments = [
    #      "--brightness"
    #      "2"
    #      "--timeout"
    #      "60"
    #    ];
    #  };
    #};
  };
}
