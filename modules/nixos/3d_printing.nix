{config, lib, pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      orca-slicer
      cura
    ];
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
