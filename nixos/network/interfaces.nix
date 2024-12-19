{ lib, ... }:
{
  config = {
    networking = {
      useNetworkd = true;
      usePredictableInterfaceNames = false;
      wireless = {
        iwd = {
          enable = true;
          settings = {
            Settings = {
              AutoConnect = true;
              # Improve roaming behavior
              RoamRetryInterval = 15;
              BackgroundScanning = true;
            };
            Network = {
              EnableIPv6 = true;
              RoutePriorityOffset = 300;
            };
          };
        };
      };
    };
    systemd.network = {
      enable = true;
      netdevs = {
        # VLANs have 3 networkd components: 
        #   - Define VLAN           ("30-eth0.100.netdev")
        #   - Define IF + link VLAN ("31-eth0.network")
        #   - Define VLAN network   ("32-eth0.100.network")
        "31-eth0.100" = {
          netdevConfig = {
            Name = "eth0.100";
            Kind = "vlan";
          };
          vlanConfig = {
            Id = 100;
          };
        };
      };
      networks = {
        "32-eth0" = {
          matchConfig = {
            Name = "eth0";
          };
          networkConfig = {
            DHCP = lib.mkDefault "yes"; # "no" if bridged
            VLAN = "eth0.100";
          };
          dhcpV4Config = {
            RouteMetric = 400;
            UseMTU = true;
          };
          ipv6AcceptRAConfig = {
            RouteMetric = 400;
          };
        };
        "33-eth0.100" = {
          matchConfig = {
            Name = "eth0.100";
          };
          networkConfig = {
            DHCP = "no";
          };
          addresses = [ # !addressConfig
            { Address = "192.168.100.101/24"; }
          ];
        };
        "42-wlan0" = {
          matchConfig.Name = "wlan0";
          networkConfig = {
            IgnoreCarrierLoss = "10s";
            DHCP = lib.mkDefault "yes";
          };
          dhcpV4Config = {
            RouteMetric = 600;
            UseMTU = true;
          };
          ipv6AcceptRAConfig.RouteMetric = 600;
        };
      };
    };
  };
}
