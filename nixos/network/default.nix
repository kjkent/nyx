{ ... }:
{
  imports = [
    ./bridge.nix
    ./firewall
    ./interfaces.nix
    ./packages.nix
    ./services.nix
  ];
}
