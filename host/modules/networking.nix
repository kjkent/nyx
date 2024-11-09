{ pkgs, lib, host, options, ... }:
{
  config = {
    boot = {
      initrd.systemd.network.wait-online.enable = false;
    };

    # Handle 4addr (WDS) setup before networkd starts
    systemd.services.wlan-4addr = {
      after = [ "systemd-modules-load.service" "local-fs.target" ];
      before = [ 
        "network-pre.target"
        "systemd-networkd.service" 
      ];
      description = "Setup 4addr mode for wlan0";
      enable = true;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.iw}/bin/iw dev wlan0 set 4addr on";
      };
      wants = [ 
        "network-pre.target"
        "systemd-modules-load.service"
        "local-fs.target"
      ];
    };

    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];
      };
      hostName = host;
      networkmanager.enable = false;
      nftables.enable = true;
      timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
      useNetworkd = true;
      usePredictableInterfaceNames = false;
      wireless = {
        iwd = {
          enable = true;
          settings = {
            Settings = {
              AutoConnect = lib.mkDefault true;
              # Improve roaming behavior
              RoamRetryInterval = 15;
              BackgroundScanning = true;
            };
            Network = {
              # Improve connection stability
              EnableIPv6 = true;
              RoutePriorityOffset = 300;
            };
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
      openssh.enable = true;
      resolved = {
        enable = true;
        dnssec = "allow-downgrade";
        fallbackDns = ["9.9.9.9" "1.1.1.1"];
      };
    };

    systemd.network = {
      enable = true;
      wait-online.enable = false;
      
      # Bridge device configuration
      links."20-br0" = {
        matchConfig.OriginalName = "br0";
        linkConfig.MACAddressPolicy = "none";  # Allows bridge to inherit MAC from port
      };

      netdevs."20-br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
          MACAddress = "none";
        };
        bridgeConfig = {
          # Improve bridge stability
          HelloTimeSec = 2;
          MaxAgeSec = 12;
          ForwardDelaySec = 4;
          STP = true;
        };
      };

      # Interface configurations
      networks = {
        "30-eth" = {
          matchConfig.Name = "eth0";
          networkConfig = {
            Bridge = "br0";
          };
          dhcpV4Config = {
            RouteMetric = 300;
            UseMTU = true;
          };
          ipv6AcceptRAConfig.RouteMetric = 300;
        };
        
        "30-wlan" = {
          matchConfig.Name = "wlan0";
          networkConfig = {
            Bridge = "br0";
            IgnoreCarrierLoss = "10s";
          };
          dhcpV4Config = {
            RouteMetric = 600;
            UseMTU = true;
          };
          ipv6AcceptRAConfig.RouteMetric = 600;
        };
        
        "40-br0" = {
          matchConfig.Name = "br0";
          networkConfig = {
            DHCP = "yes";
          };
          dhcpV4Config = {
            RouteMetric = 100;
            UseMTU = true;
          };
          ipv6AcceptRAConfig.RouteMetric = 100;
          linkConfig.RequiredForOnline = "carrier";
        };
      };
    };
  };
}
