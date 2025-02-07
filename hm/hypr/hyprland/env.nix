{
  config.wayland.windowManager.hyprland.settings = let
    uw = exe: "uwsm app -- ${exe}";
  in {
    env = [
      "ELECTRON_OZONE_PLATFORM_HINT,auto"
      "CHROMIUM_FLAGS,--enable-features=UseOzonePlatform --enable-gpu-rasterization --ignore-gpu-blocklist --enable-zero-copy"

      ### XDG Spec
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"

      ### Toolkit Backends
      "CLUTTER_BACKEND,wayland"
      "GDK_BACKEND,wayland,x11,*"
      "SDL_VIDEODRIVER=wayland"
      # doesn't work with android studio
      # https://github.com/NixOS/nixpkgs/issues/267176
      #"QT_QPA_PLATFORM=wayland;xcb" 
      "QT_QPA_PLATFORM=xcb;wayland"

      # QT
      "QT_WAYLAND_DISABLE_WINDOWDECORATION=1"
      "QT_AUTO_SCREEN_SCALE_FACTOR=1" # Auto scaling per monitor pixel density
    ];

    exec-once = [
      (uw "dbus-update-activation-environment --systemd --all")
      (uw "systemctl --user start hyprpaper")
      (uw "waybar")
      (uw "swaync")
    ];
  };
}
