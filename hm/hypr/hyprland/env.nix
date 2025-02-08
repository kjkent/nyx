{config, lib, ...}: let
  inherit (lib.strings) removePrefix;
in {
  config = {
    wayland.windowManager.hyprland.settings = {
      env = [
      ### For theming, xcursor, nvidia, toolkit env vars
      ## the below should not be needed, with the GDK/SDL/QT vars
      ## potentially being harmful (despite hyprland wiki)
      #"CLUTTER_BACKEND,wayland"
      #"GDK_BACKEND,wayland,x11,*"
      #"SDL_VIDEODRIVER,wayland"
      #"QT_QPA_PLATFORM,wayland;xcb"
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"

      "NIXOS_OZONE_WL,1"
      "ELECTRON_OZONE_PLATFORM_HINT,auto"
      "CHROMIUM_FLAGS,--enable-features=UseOzonePlatform --enable-gpu-rasterization --ignore-gpu-blocklist --enable-zero-copy"
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"

      ];
      exec-once = [
        "waybar"
        "swaync"
      ];
    };
  };
}
