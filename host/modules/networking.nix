{ pkgs, lib, host, options, ... }:
{
  config = {
    boot = {
      initrd.systemd.network.wait-online.enable = false;
    };

    # Enable WDS (aka 4addr) for wlan0. The interface needs to have carrier
    # before 4addr command can work; but networkd waits for noone. So, here
    # we wait for wlan0 to attain carrier state, then issue the command to
    # enable 4addr, then tell networkd to reconfigure the interface.
    systemd.services.wlan-4addr = let 
      deps = [ 
        "network.target"
        "systemd-networkd.service"
        "sys-subsystem-net-devices-wlan0.device"
      ];
      ifName = "wlan0";
    in {
      after = deps;
      wants = deps;
      description = "Set WDS/4addr mode for ${ifName} and reconfigure systemd-networkd.";
      enable = true;
      serviceConfig = {
        Type = "oneshot";
        TimeoutSec = 10;
        RemainAfterExit = true;
        ExecStart = with pkgs; [
          # `-` prepending an executable path == ignore failure
          "-${systemd}/lib/systemd/systemd-networkd-wait-online --interface=${ifName} --operational-state=carrier --timeout=5"
          "${iw}/bin/iw dev ${ifName} set 4addr on"
          "${systemd}/bin/networkctl reconfigure ${ifName}"
        ];
      };
      wantedBy = [ "multi-user.target" ];
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
        #dnssec = "allow-downgrade";   # TODO: These two settings are vulnerable
        #dnsovertls = "opportunistic"; #       to MITM downgrading attacks.
        dnssec = "false";     # Sept 2023: SD devs state implementation is not robust enough.
        dnsovertls = "false"; # +++ Disable prior to LAN DOT/DNSSEC implementation.
        fallbackDns = ["1.1.1.1" "1.2.2.1" "9.9.9.9"];
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
