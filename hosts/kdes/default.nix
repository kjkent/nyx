{nixosModulesPath, ...}: {
  imports = [
    "${nixosModulesPath}/amd.nix"
  ];
  config = {
    system.stateVersion = "24.11";
    hardware.keyboard.layout = "us";
    hardware.nvidia.enable = true;
    networking.networkBridge.enable = true;
    programs.hyprland.monitors = [
      "HDMI-A-1,2560x1080@60,0x0,1"
      "DP-1,1920x1080@75,-1920x-310,1"
    ];
  };
}
