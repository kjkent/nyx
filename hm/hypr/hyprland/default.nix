{
  lib,
  osConfig,
  ...
}:
{
  imports = [
    ./binds.nix
    ./env.nix
    ./style.nix
    ./windows.nix
  ];
  config = {
    services.hyprpaper.enable = true; # stylix sets wallpaper using hyprpaper
    wayland.windowManager.hyprland = {
      enable = true;
      # if on HM > 02-2026, set the Hyprland and XDPH packages to null to use the ones from the NixOS module
      # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos
      #package = null;
      #portalPackage = null;
      systemd = {
        enable = true;
        enableXdgAutostart = true;
        variables = ["--all"]; # == `exec-once = dbus-update-activation-environment --systemd --all`
      };
      settings = {
        monitor = osConfig.programs.hyprland.monitors;
        cursor = {
          no_hardware_cursors = if osConfig.hardware.nvidia.enable then 1 else 0;
          # 0: off, 1: on, 2: auto
          use_cpu_buffer = if osConfig.hardware.nvidia.enable then 1 else 2;
        };
        input = {
          kb_layout = "${osConfig.hardware.keyboard.layout}";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = 1;
            disable_while_typing = 1;
            scroll_factor = 1;
          };
          sensitivity = 0.5;
          accel_profile = "flat";
        };
        gestures = {
          workspace_swipe = 1;
          workspace_swipe_fingers = 2;
        };
        misc = {
          disable_hyprland_logo = 1;
          disable_splash_rendering = 1;
          initial_workspace_tracking = 0;
          mouse_move_enables_dpms = 1;
          key_press_enables_dpms = 0;
        };
        render = {
          allow_early_buffer_release = 0;
        };
      };
    };
  };
}
