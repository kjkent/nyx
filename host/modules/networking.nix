{ lib, host, options, ... }:
{
  config = {
    networking = {
      networkmanager = {
        enable = true;
        wifi = {
          backend = "iwd";
        };
      };
      hostName = host;
      timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
      firewall = {
        enable = true;
        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];
      };
      wireless = {
        iwd = {
          enable = true;
          settings = {
            IPv6.Enabled = true;
            Settings.AutoConnect = lib.mkDefault true;
          };
        };
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
