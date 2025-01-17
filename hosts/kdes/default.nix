{nixosModulesPath, ...}: {
  imports = [
    "${nixosModulesPath}/amd.nix"
  ];
  config = {
    system.stateVersion = "24.11";
    hardware.keyboard.layout = "us";
    hardware.nvidia.enable = true;
    networking.networkBridge.enable = true;
    # default == actual_cores(max-jobs+cores)
    programs.hyprland.monitors = [
      "HDMI-A-1, 2560x1080, 0x0, 1"
      "DP-1, 1920x1080, -1080x-310, 1, transform, 1"
    ];
  };
}
