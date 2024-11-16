{ lib, trustedNetwork, ... }:
{
  config = {
    networking = {
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
      networks = {
        "00-trusted-networks" = {
          matchConfig.SSID = trustedNetwork;
          dhcpV4Config = {
            UseDNS = true;
          };
          dhcpV6Config = {
            UseDNS = true;
          };
        };
        "30-eth0" = {
          matchConfig.Name = "eth0";
          networkConfig = {
            DHCP = lib.mkDefault "yes"; # "no" if bridged
          };
          dhcpV4Config = {
            RouteMetric = 400;
            UseMTU = true;
            UseDNS = true;
          };
          dhcpV6Config = {
            UseDNS = true;
          };
          ipv6AcceptRAConfig.RouteMetric = 400;
        };
        "30-wlan0" = {
          matchConfig.Name = "wlan0";
          networkConfig = {
            IgnoreCarrierLoss = "10s";
            DHCP = lib.mkDefault "yes";
          };
          dhcpV4Config = {
            RouteMetric = 600;
            UseDNS = false;
            UseMTU = true;
          };
          dhcpV6Config = {
            useDNS = false;
          };
          ipv6AcceptRAConfig.RouteMetric = 600;
        };
      };
    };
  };
}
