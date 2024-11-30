let
  modDir = ../modules/nixos;
in
{
  kdes = _: {
    imports = [
      "${modDir}/network/firewall/klipper.nix"
      "${modDir}/amd.nix"
    ];
    config = {
      system.stateVersion = "24.11";
      hardware.keyboard.layout = "us";
      hardware.nvidia.enable = true;
      networking.networkBridge.enable = true;
      programs.hyprland.monitors = [
        "HDMI-A-1, 2560x1080, 0x0, 1"
        "DP-1, 1920x1080, -1080x0, 1, transform, 1"
      ];
    };
  };
  klap = _: {
    imports = [
      "${modDir}/i915.nix"
      "${modDir}/thinkpad.nix"
      "${modDir}/laptop_power.nix"
    ];
    config = {
      system.stateVersion = "24.11";
      hardware.keyboard.layout = "gb";
    };
  };
}
