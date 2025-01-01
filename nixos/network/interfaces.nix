{lib, ...}: {
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
    systemd.network = let
      eth.name = "eth0";
      wlan.name = "wlan0";
      vlan = rec {
        tag = 100;
        name = "${eth.name}.${builtins.toString tag}";
        ipCidr = "192.168.100.101/24";
      };
    in {
      enable = true;
      netdevs = {
        # VLANs have 3 networkd components:
        #   - Define VLAN           ("30-eth0.100.netdev")
        #   - Define IF + link VLAN ("31-eth0.network")
        #   - Define VLAN network   ("32-eth0.100.network")
        "30-${vlan.name}" = {
          netdevConfig = {
            Name = vlan.name;
            Kind = "vlan";
          };
          vlanConfig = {
            Id = vlan.tag;
          };
        };
      };
      networks = {
        "31-${eth.name}" = {
          matchConfig = {
            Name = eth.name;
          };
          networkConfig = {
            DHCP = lib.mkDefault "yes"; # "no" if bridged
            VLAN = [vlan.name];
          };
          dhcpV4Config = {
            RouteMetric = 400;
            UseMTU = true;
          };
          ipv6AcceptRAConfig = {
            RouteMetric = 400;
          };
        };
        "32-${vlan.name}" = {
          matchConfig = {
            Name = vlan.name;
          };
          networkConfig = {
            DHCP = "no";
          };
          addresses = [
            # !addressConfig
            {Address = vlan.ipCidr;}
          ];
        };
        "42-${wlan.name}" = {
          matchConfig.Name = wlan.name;
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
