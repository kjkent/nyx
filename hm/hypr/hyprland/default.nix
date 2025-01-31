{
  lib,
  osConfig,
  pkgs,
  ...
}:
with osConfig; {
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
      # conflicts with `uwsm` session management in nixos module
      systemd.enable = false;
      settings = {
        monitor = programs.hyprland.monitors;
        cursor.use_cpu_buffer = lib.mkIf hardware.nvidia.enable true;
        input = {
          kb_layout = "${hardware.keyboard.layout}";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
            scroll_factor = 1;
          };
          sensitivity = 0.5;
          accel_profile = "flat";
        };
        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 2;
        };
        misc = {
          initial_workspace_tracking = 0;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = false;
        };
      };
    };
  };
}
