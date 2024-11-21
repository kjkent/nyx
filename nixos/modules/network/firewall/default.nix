_: {
  imports = [
    ./syncthing.nix
    ./klipper.nix
  ];
  config = {
    networking = {
      firewall.enable = true;
      nftables.enable = true;
    };
  };
}
