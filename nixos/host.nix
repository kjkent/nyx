{ hostName, ... }:
let
  machines = {
  kdes = {
    imports = [
      ./network/firewall/klipper.nix
      ./nvidia.nix
      ./amd.nix
    ];
    config = {
      hardware.keyboard.layout = "us";
      networking.networkBridge.enable = true;
      programs.hyprland.monitors = [
        "HDMI-A-1, 2560x1080, 0x0, 1"
        "DP-1, 1920x1080, -1080x0, 1, transform, 1"
      ];
    };
  };
  klap = {
    imports = [
      ./i915.nix
      ./thinkpad.nix
      ./laptop_power.nix
    ];
    config = {
      hardware.keyboard.layout = "gb";
    };
  };
  };
in
{
  inherit (machines.${hostName}) imports config;
}
