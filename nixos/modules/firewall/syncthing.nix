# Firewall config for Syncthing.
# https://docs.syncthing.net/users/firewall.html
_: {
  config = {
    networking.firewall = {
      allowedUDPPorts = [
        22000 # QUIC-based sync
        21027 # Discovery broadcasts
      ];
      allowedTCPPorts = [
        22000 # TCP-based sync
      ];
    };
  };
}
