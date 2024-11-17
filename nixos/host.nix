{ host, ... }:
let
  hostModules = {
    kdes = {
      imports = [
        ./modules/nvidia.nix
        ./modules/amd.nix
      ];
      config = {
        hardware.keyboard.layout = "us";
        nyx.networkBridge.enable = true;
        programs.hyprland.monitors = [
          "HDMI-A-1, 2560x1080, 0x0, 1"
          "DP-1, 1920x1080, -1080x0, 1, transform, 1"
        ];
      };
    };
    klap = {
      imports = [
        ./modules/i915.nix
        ./modules/thinkpad.nix
        ./modules/laptop_power.nix
      ];
      config = {
        hardware.keyboard.layout = "gb";
      };
    };
  };
in
{
  imports = [
    ./modules # Shared/base modules
  ] ++ hostModules.${host}.imports;

  inherit (hostModules.${host}) config;
}
