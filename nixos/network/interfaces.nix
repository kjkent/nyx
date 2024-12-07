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
      networks = {
        "30-eth0" = {
          matchConfig.Name = "eth0";
          networkConfig = {
            DHCP = lib.mkDefault "yes"; # "no" if bridged
          };
          dhcpV4Config = {
            RouteMetric = 400;
            UseMTU = true;
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
            UseMTU = true;
          };
          ipv6AcceptRAConfig.RouteMetric = 600;
        };
      };
    };
  };
}
