{pkgs, ...}: {
  config = {
    boot = {
      kernelPackages = pkgs.linuxPackages_zen;
      kernel.sysctl = {
        # Needed for some Steam games
        "vm.max_map_count" = 2147483642;
        # Some server/db software tweaks
        "vm.overcommit_memory" = 1;
        "net.core.rmem_max" = 7500000; # Recommended by QUIC docs
        "net.core.wmem_max" = 7500000;
      };
    };
  };
}
