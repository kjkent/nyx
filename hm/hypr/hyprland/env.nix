{config, lib, ...}: let
  inherit (lib.strings) removePrefix;
in {
  config = {
    home.file = let
      uwsmCfgDir = removePrefix 
        "${config.home.homeDirectory}/"
        "${(config.xdg.configHome)}/uwsm";
    in {
      ### For theming, xcursor, nvidia, toolkit env vars
      ## the below should not be needed, with the GDK/SDL/QT vars
      ## potentially being harmful (despite hyprland wiki)
      #export XDG_CURRENT_DESKTOP=Hyprland
      #export XDG_SESSION_DESKTOP=Hyprland
      #export XDG_SESSION_TYPE=wayland
      #export GDK_BACKEND=wayland,x11,*
      #export SDL_VIDEODRIVER=wayland
      #export QT_QPA_PLATFORM=wayland;xcb
      "${uwsmCfgDir}/env".text = ''
        export ELECTRON_OZONE_PLATFORM_HINT=auto
        export CHROMIUM_FLAGS,--enable-features=UseOzonePlatform --enable-gpu-rasterization --ignore-gpu-blocklist --enable-zero-copy
        export QT_AUTO_SCREEN_SCALE_FACTOR=1
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      ''; 
      ## For HYPR*, AQ_* env vars
      #"${uwsmCfgDir}/env-hyprland".text = ''
      #
      #'';
    };
    wayland.windowManager.hyprland.settings = let
      uw = exe: "uwsm app -- ${exe}";
    in {
      exec-once = [
        # handled by uwsm: (uw "dbus-update-activation-environment --systemd --all")
        (uw "systemctl --user start hyprpaper")
        (uw "waybar")
        (uw "swaync")
      ];
    };
  };
}
