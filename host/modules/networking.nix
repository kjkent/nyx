{ pkgs, lib, host, options, ... }:
{
  config = {
    boot = {
      initrd.systemd.network.wait-online.enable = false;
    };
    #environment.systemPackages = with pkgs; [ firewalld firewalld-gui ];
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
      openssh.enable = true;
      resolved.enable = true;
      # Enables 4addr (aka WDS) on wlan interface, facilitating bridging.
      udev.packages = with pkgs; [
        (writeTextFile rec {
          name = "01-wlan0-4addr.rules"; ## NixOS sets $PATH in 00-path.rules
          destination = "/etc/udev/rules.d/${name}";
          text = ''
            ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan0", RUN+="${iw}/bin/iw dev wlan0 set 4addr on"
          '';
        })
      ]; 
    };
    systemd.network = {
      enable = true;
      wait-online.enable = false;
      links = {
        "20-br0" = {
          matchConfig.OriginalName = "br0";
          linkConfig.MACAddressPolicy = "none";
        };
      };
      netdevs."20-br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
          MACAddress = "none";
        };
      };
      networks = {
        "30-eth" = {
          matchConfig.Name = "eth0";
          networkConfig.Bridge = "br0";
          dhcpV4Config.RouteMetric = 300;
          ipv6AcceptRAConfig.RouteMetric = 300;
        };
        "30-wlan" = {
          matchConfig.Name = "wlan0";
          networkConfig.IgnoreCarrierLoss = "3s";
          networkConfig.Bridge = "br0";
          dhcpV4Config.RouteMetric = 600;
          ipv6AcceptRAConfig.RouteMetric = 600;
        };
        "40-br0" = {
          matchConfig.Name = "br0";
          networkConfig.DHCP = "yes";
          dhcpV4Config.RouteMetric = 100;
          ipv6AcceptRAConfig.RouteMetric = 100;
        };
      };
    };
  };
}
