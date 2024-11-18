_: {
  imports = [
    ./syncthing.nix
  ];
  config = {
    networking = {
      firewall.enable = true;
      nftables.enable = true;
    };
  };
}
