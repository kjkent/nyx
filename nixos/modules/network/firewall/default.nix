_: {
  imports = [
    ./syncthing.nix
    # ./klipper.nix # Only used on desktop
  ];
  config = {
    networking = {
      firewall.enable = true;
      nftables.enable = true;
    };
  };
}
