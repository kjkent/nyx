_: {
  config = {
    boot = {
      kernel.sysctl = {
        # TODO: This is a minor security risk; consider alternatives.
        "net.ipv4.ip_unprivileged_port_start" = 0;

        # explicit congestion notifications
        "net.ipv4.tcp_ecn" = 1; # 0: disable / 1: ask and accept / 2: accept

        # Use Google's fancy congestion control algo
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "fq";

        # Performance tweaks from ArchWiki on sysctl
        "net.ipv4.tcp_mtu_probing" = 1;
        "net.ipv4.tcp_fastopen" = 3; # 1: default, 3: incoming+outgoing, 1027: enable for all, inc non-specified
        "net.ipv4.tcp_slow_start_after_idle" = 0;
      };
      kernelModules = ["tcp_bbr"];
    };
  };
}
