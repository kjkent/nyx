{ lib, host, options, ... }:
{
  config = {
    boot = {
      initrd.systemd.network.wait-online.enable = false;
      kernelParams = [ "net.ifnames=0" ]; # Disable Predictable Network Interface Names
    };
    networking = {
      firewall = {
        enable = false;
        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];
      };
      hostName = host;
      networkmanager = {
        enable = true;
        wifi = {
          backend = "iwd";
        };
      };
      nftables.enable = true;
      timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
      useDHCP = lib.mkDefault true; # Gets overridden to false by NM config
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
    systemd.network = {
      enable = true;
      wait-online.enable = false;
      links = {
        "30-br0" = {
          matchConfig.OriginalName = "br0";
          linkConfig.MACAddressPolicy = "none";
        };
        #"99-default" = {    ##### Causes permission denied error. Setting via kernel param.
        #  linkConfig.NamePolicy = "keep kernel";
        #};
      };
      netdevs."30-br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
          MACAddress = "none";
        };
      };
      networks = {
        "20-eth" = {
          matchConfig.Name = "eth0";
          linkConfig.RequiredForOnline = "routable";
          networkConfig = {
            # DHCP = "yes";
            Bridge = "br0";
          };
          dhcpV4Config.RouteMetric = 300;
          ipv6AcceptRAConfig.RouteMetric = 300;
        };
        "25-wlan" = {
          matchConfig.Name = "wlan0";
          #linkConfig.RequiredForOnline = "routable";
          networkConfig = {
            #DHCP = "yes";
            #IgnoreCarrierLoss = "3s";
            Bridge = "br0";
          };
          dhcpV4Config.RouteMetric = 600;
          ipv6AcceptRAConfig.RouteMetric = 600;
        };
        "30-br0" = {
          matchConfig.Name = "br0";
          linkConfig.RequiredForOnline = "routable";
          networkConfig.DHCP = "yes";
          dhcpV4Config.RouteMetric = 100;
          ipv6AcceptRAConfig.RouteMetric = 100;

        };
      };
    };
    #environment.systemPackages = with pkgs; [ firewalld firewalld-gui ];

  };
}
