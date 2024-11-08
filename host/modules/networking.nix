{ pkgs, lib, host, options, ... }:
{
  config = {
    boot = {
      initrd.systemd.network.wait-online.enable = false;
      #kernelParams = [ "net.ifnames=0" ]; # Trialling nixos option below - Disable Predictable Network Interface Names
    };
    networking = {
      firewall = {
        enable = false;
        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];
      };
      hostName = host;
      networkmanager = {
        enable = false;
        wifi = {
          backend = "iwd";
        };
      };
      nftables.enable = true;
      timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
      useNetworkd = true;
      usePredictableInterfaceNames = false;
      wireless = {
        iwd = {
          enable = true;
          settings = {
            IPv6.Enabled = false;
            Settings.AutoConnect = lib.mkDefault true;
          };
        };
      };
    };
    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      nfs.server.enable = false;
      openssh.enable = true;
      rpcbind.enable = false;
      # Enables 4addr on wlan interface, facilitating bridging.
      udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="net", INTERFACE=="wlan0", RUN+="${pkgs.iw}/bin/iw dev wlan0 set 4addr on"
      '';
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
          linkConfig.RequiredForOnline = "routable";
          networkConfig = {
            #DHCP = "yes";
            IgnoreCarrierLoss = "3s";
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
