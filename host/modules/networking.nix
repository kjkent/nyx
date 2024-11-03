{ host, options, ... }:
{
  config = {
    networking = {
      networkmanager.enable = true;
      hostName = host;
      timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
      firewall = {
        enable = true;
        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];
      };
    };
    services = {
      openssh.enable = true;
      rpcbind.enable = false;
      nfs.server.enable = false;
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
