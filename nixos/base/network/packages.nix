{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      dnsutils # dig, delv, nslookup, nsupdate
      ethtool # Low-level ethernet cli tool
      impala # wifi management tui
      inetutils
      iw # Low-level wifi adapter cli tool
      protonvpn-gui
      nmap
      wireguard-tools
    ];
  };
}
