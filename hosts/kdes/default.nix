{nixosModulesPath, ...}: {
  config = {
    system.stateVersion = "24.11";
    hardware = {
    amd.enable = true;
    keyboard.layout = "us";
    nvidia.enable = true;
    };
    networking.networkBridge.enable = true;
    programs.hyprland.monitors = [
      "HDMI-A-1,2560x1080@60,0x0,1"
      "DP-1,1920x1080@75,-1920x10,1"
    ];
  };
}
