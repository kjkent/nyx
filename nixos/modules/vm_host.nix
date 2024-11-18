{
  lib,
  config,
  ...
}: {
  options = with lib; {
    virtualisation.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable virtualisation configuration.";
    };
  };

  config = lib.mkIf config.virtualisation.enable {
    boot = {
      kernel.sysctl = {
        # Needed for some Steam games
        "vm.max_map_count" = 2147483642;
        # Some server/db software tweaks
        "vm.overcommit_memory" = 1;
        "net.core.rmem_max" = 2500000;
        "net.core.wmem_max" = 2500000;
        # (br_netfilter) Used to allow libvirt bridged networking
        "net.bridge.bridge-nf-call-arptables" = 0;
        "net.bridge.bridge-nf-call-iptables" = 0;
        "net.bridge.bridge-nf-call-ip6tables" = 0;
        # TODO: This is a minor security risk; consider alternatives.
        "net.ipv4.ip_unprivileged_port_start" = 0;
      };
      kernelModules = ["br_netfilter"];
    };

    programs = {
      virt-manager.enable = true;
      dconf.profiles.user.databases = [
        {
          settings = {
            "org/virt-manager/virt-manager/connections" = {
              autoconnect = ["qemu:///system"];
              uris = ["qemu:///system"];
            };
          };
        }
      ];
    };

    virtualisation = {
      libvirtd.enable = true;
      podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
