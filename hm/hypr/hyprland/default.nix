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
    services.hyprpaper.enable = true;
    wayland.windowManager.hyprland = {
      enable = true;
      systemd = {
        enable = true;
        enableXdgAutostart = true;
        variables = ["--all"]; # == `exec-once = dbus-update-activation-environment --systemd --all`
      };
      settings = {
        monitor = osConfig.programs.hyprland.monitors;
        cursor = {
          no_hardware_cursors = if osConfig.hardware.nvidia.enable then 1 else 0;
        };
        input = {
          kb_layout = osConfig.hardware.keyboard.layout;
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
      };
    };
  };
}
