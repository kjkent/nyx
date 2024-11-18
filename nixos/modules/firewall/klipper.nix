_: {
  config = {
    networking.firewall = {
      allowedTCPPorts = [
        80   # Fluidd web-app access
        7125 # Moonraker API
      ];
    };
  };
}
