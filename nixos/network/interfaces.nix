{config, lib, pkgs, ...}: let
  bridge.name = "br0";
  eth.name = "eth0";
  wlan.name = "wlan0";
  vlan = rec {
    tag = 100;
    name = "${eth.name}.${builtins.toString tag}";
    # TODO: Will cause IP conflict if lap + des are connected via eth
    ipCidr = "192.168.100.101/24";
  };
in {
  options = with lib; with types; {
    networking.networkBridge = {
      enable = mkOption {
        type = bool;
        default = false;
        description = "Whether to enable ${bridge.name} and attach ${wlan.name}.";
      };
      includeWlan = mkOption {
        type = bool;
        default = false;
        description = "Whether to add ${wlan.name} to ${bridge.name} - Warning: sketchy af.";
      };
    };
  };
  config = let
    cfg = config.networking.networkBridge;
    bridging = cfg.enable;
    wlanBridging = cfg.includeWlan;
  in {
    boot = lib.mkIf bridging {
      kernel.sysctl = {
        # (br_netfilter) Used to allow libvirt bridged networking
        "net.bridge.bridge-nf-call-arptables" = 0;
        "net.bridge.bridge-nf-call-iptables" = 0;
        "net.bridge.bridge-nf-call-ip6tables" = 0;
      };
      kernelModules = ["br_netfilter"];
    };

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
    systemd = {
      network = {
        enable = true;
        links."20-${bridge.name}" = lib.mkIf bridging {
          matchConfig.OriginalName = bridge.name;
          linkConfig.MACAddressPolicy = "none"; # Allows bridge to inherit MAC from eth0
        };

        netdevs = {
          "21-${bridge.name}" = lib.mkIf bridging {
            netdevConfig = {
              # Also needed to inherit MAC from eth0
              Name = bridge.name;
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
          "22-${bridge.name}" = lib.mkIf bridging {
            matchConfig.Name = bridge.name;
            networkConfig = {
              DHCP = "yes";
              UseDomains = true;
            };
            dhcpV4Config = {
              RouteMetric = 200;
              UseMTU = true;
            };
            ipv6AcceptRAConfig.RouteMetric = 200;
          };
          "31-${eth.name}" = {
            matchConfig = {
              Name = eth.name;
            };
            networkConfig = {
              Bridge = lib.mkIf bridging bridge.name;
              DHCP = if bridging then "no" else "yes";
              VLAN = [vlan.name];
              UseDomains = true; # Enables acquiring search path from DHCP

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
          "40-${wlan.name}" = {
            matchConfig.Name = wlan.name;
            networkConfig = {
              Bridge = lib.mkIf wlanBridging bridge.name;
              DHCP = if wlanBridging then "no" else "yes";
              IgnoreCarrierLoss = "10s";
              UseDomains = true;
            };
            dhcpV4Config = {
              RouteMetric = 600;
              UseMTU = true;
            };
            ipv6AcceptRAConfig.RouteMetric = 600;
          };
        };
      };
      # Enables WDS (aka 4addr) for wlan0. The interface needs to have carrier
      # before 4addr command can work; but networkd waits for noone. So, here
      # we wait for wlan0 to attain carrier state, then issue the command to
      # enable 4addr, then tell networkd to reconfigure the interface.
      services.wlan-4addr = let
        deps = [
          "network.target"
          "systemd-networkd.service"
          "sys-subsystem-net-devices-${wlan.name}.device"
        ];
      in lib.mkIf wlanBridging {
          after = deps;
          wants = deps;
          description = "Set WDS/4addr mode for ${wlan.name} and reconfigure systemd-networkd.";
          enable = true;
          serviceConfig = {
            Type = "oneshot";
            TimeoutSec = 10;
            RemainAfterExit = true;
            ExecStart = with pkgs; [
              # `-` prepending an executable path == ignore failure
              "-${systemd}/lib/systemd/systemd-networkd-wait-online --interface=${wlan.name} --operational-state=carrier --timeout=5"
              "${iw}/bin/iw dev ${wlan.name} set 4addr on"
              "${systemd}/bin/networkctl reconfigure ${wlan.name}"
            ];
          };
          wantedBy = ["graphical.target"];
        };
    };
  };
}
