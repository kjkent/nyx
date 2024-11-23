# TODO:
# - A bond may be better than this routemetric approach?
# - Connectivity fails when using ProtonVPN (which depends on NetworkManager).
# - 4addr on WiFi is super tempermental so restricting by default to ethernet.
{
  lib,
  pkgs,
  config,
  ...
}:
{
  options =
    with lib;
    with types;
    {
      networking.networkBridge = {
        enable = mkOption {
          type = bool;
          default = false;
          description = "Whether to enable br0 and attach eth0.";
        };
        includeWlan = mkOption {
          type = bool;
          default = false;
          description = "Whether to add wlan0 to br0 - Warning: sketchy af.";
        };
      };
    };

  config =
    let
      cfg = config.networking.networkBridge;
    in
    lib.mkIf cfg.enable {
      systemd.network = {
        enable = true;

        # Bridge configuration
        links."20-br0" = {
          matchConfig.OriginalName = "br0";
          linkConfig.MACAddressPolicy = "none"; # Allows bridge to inherit MAC from eth0
        };

        netdevs."20-br0" = {
          netdevConfig = {
            # Also needed to inherit MAC from eth0
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
          "30-eth0".networkConfig = {
            Bridge = "br0";
            DHCP = "no";
          };
          "30-wlan0".networkConfig = lib.mkIf cfg.includeWlan {
            Bridge = "br0";
            DHCP = "no";
          };
          "40-br0" = {
            matchConfig.Name = "br0";
            networkConfig = {
              DHCP = "yes";
            };
            dhcpV4Config = {
              RouteMetric = 200;
              UseMTU = true;
            };
            ipv6AcceptRAConfig.RouteMetric = 200;
          };
        };
      };

      # Enables WDS (aka 4addr) for wlan0. The interface needs to have carrier
      # before 4addr command can work; but networkd waits for noone. So, here
      # we wait for wlan0 to attain carrier state, then issue the command to
      # enable 4addr, then tell networkd to reconfigure the interface.
      systemd.services.wlan-4addr =
        let
          deps = [
            "network.target"
            "systemd-networkd.service"
            "sys-subsystem-net-devices-wlan0.device"
          ];
          ifName = "wlan0";
        in
        lib.mkIf cfg.includeWlan {
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
          wantedBy = [ "graphical.target" ];
        };

      networking = {
        useNetworkd = true;
        usePredictableInterfaceNames = false;
      };
    };
}
