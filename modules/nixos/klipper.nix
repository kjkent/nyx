{config, lib, ...}: {
  options = {
    services.klipper.custom = {
      enable = with lib; mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable self-managed Klipper";
      };
    };
  };
  config = lib.mkIf config.services.klipper.custom.enable {
    networking.firewall = {
      allowedTCPPorts = [
        80 # Fluidd web-app access
        7125 # Moonraker API
      ];
    };
    # Persistent printer tty at /dev/tty3DP
    services.udev.extraRules = ''
      SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", SYMLINK+="tty3D"
    '';
  };
}
