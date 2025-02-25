{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    boot = {
      kernelPackages = pkgs.linuxPackages_zen;
      # For libreboot internal flashing -- security risk
      kernelParams = lib.mkIf config.boot.isBios ["iomem=relaxed"];
      kernel.sysctl = {
        "kernel.sysrq" = 1; # Enable all SysRq functions. https://docs.kernel.org/admin-guide/sysrq.html
        "net.core.rmem_max" = 7500000; # Recommended by QUIC docs
        "net.core.wmem_max" = 7500000;
        # Needed for some Steam games
        "vm.max_map_count" = 2147483642;
        # Some server/db software tweaks
        "vm.overcommit_memory" = 1;
      };
    };
  };
}
