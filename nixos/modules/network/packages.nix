{pkgs,...}: {
  config = {
    environment.systemPackages = with pkgs; [
      networkmanagerapplet
      wireguard-tools
      protonvpn-gui
      dnsutils # dig, delv, nslookup, nsupdate
      nmap
      ethtool # Low-level ethernet cli tool
      inetutils
      iw # Low-level wifi adapter cli tool
    ];
  };
}
