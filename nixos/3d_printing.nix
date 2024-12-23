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
    # Persistent printer tty at /dev/tty3DPrinter with current user access
    services.udev.packages = [
      (pkgs.writeTextFile rec { 
        name = "3d-printer";
        text = ''
          SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", TAG+="uaccess", SYMLINK+="tty3dPrinter"
        '';
        destination = "/etc/udev/rules.d/70-${name}.rules";
      })
    ];
  };
}
