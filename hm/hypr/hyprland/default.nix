{osConfig, ...}: {
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
        input = {
          kb_layout = osConfig.hardware.keyboard.layout;
          follow_mouse = true;
          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
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
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          initial_workspace_tracking = false;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = false;
        };
      };
    };
  };
}
