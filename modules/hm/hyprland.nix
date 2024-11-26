{ osConfig, pkgs, ... }:
with osConfig;
{
  config = {
    home.packages = with pkgs; [ hyprpicker ];
    wayland.windowManager.hyprland = {
      enable = true;
      # Adds `dbus-update-activation-environment --systemd --all`
      systemd.variables = [ "--all" ];
      settings = {
        "$mod" = "SUPER";
        env = [
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "CHROMIUM_FLAGS,--enable-features=UseOzonePlatform --enable-gpu-rasterization --ignore-gpu-blocklist --enable-zero-copy"

          ### XDG Spec
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"

          ### Toolkit Backends
          "GDK_BACKEND,wayland,x11,*"
          "SDL_VIDEODRIVER=wayland"
          "QT_QPA_PLATFORM=wayland;xcb"
          "CLUTTER_BACKEND,wayland"

          # QT
          "QT_WAYLAND_DISABLE_WINDOWDECORATION=1"
          "QT_AUTO_SCREEN_SCALE_FACTOR=1" # Auto scaling per monitor pixel density
        ];

        exec-once = [
          "waybar"
          "swaync"
        ];

        monitor = programs.hyprland.monitors;

        general = {
          gaps_in = 6;
          gaps_out = 8;
          border_size = 2;
          layout = "dwindle";
          resize_on_border = true;
        };

        # NVIDIA compat.
        # TODO: Test if this can be enabled by flipping the booleans.
        cursor = {
          no_hardware_cursors = true;
          allow_dumb_copy = false;
        };

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

        windowrule = [
          "float,nm-connection-editor|blueman-manager"
          "float,swayimg|Viewnior|pavucontrol"
        ];

        windowrulev2 = [
          "stayfocused,title:^$,class:^steam$"
          "minsize 1 1,title:^$,class:^steam$"
          "opacity 0.9 0.7,class:^thunar$"
          "tile,class:^(\.)?scrcpy(-wrapped)?$"
          "float,title:^(Select|Open|Save) (File|Image|Folder)$"
          "float,title:^Welcome to WebStorm$"
        ];

        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 2;
        };

        misc = {
          initial_workspace_tracking = 0;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = false;
        };

        animations = {
          enabled = true;
          bezier = [
            "wind,0.05,0.9,0.1,1.05"
            "winIn,0.1,1.1,0.1,1.1"
            "winOut,0.3,-0.3,0,1"
            "liner,1,1,1,1"
          ];
          animation = [
            "windows,1,6,wind,slide"
            "windowsIn,1,6,winIn,slide"
            "windowsOut,1,5,winOut,slide"
            "windowsMove,1,5,wind,slide"
            "border,1,1,liner"
            "fade,1,10,default"
            "workspaces,1,5,wind"
          ];
        };

        decoration = {
          rounding = 10;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
          };
          blur = {
            enabled = true;
            size = 5;
            passes = 3;
            new_optimizations = true;
            ignore_opacity = false;
          };
        };

        plugins = {
          hyprtrails = { };
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        bind =
          [
            "$mod,Return,exec,foot"
            "$mod,B,exec,exec firefox"
            "$mod,S,exec,screenshot"
            "$mod,D,exec,rofi -show drun"
            "$mod,O,exec,obsidian"
            "$mod,C,exec,hyprpicker -a"
            "$mod,G,exec,gimp"
            "$mod,F,exec,thunar"
            "$mod,M,exec,spotify"
            "$mod,Q,killactive"
            "$mod,P,pseudo"
            "$mod SHIFT,/,togglesplit"
            "$mod SHIFT,F,fullscreen"
            "$mod SHIFT,T,togglefloating"
            "$mod SHIFT,left,movewindow,l"
            "$mod SHIFT,right,movewindow,r"
            "$mod SHIFT,up,movewindow,u"
            "$mod SHIFT,down,movewindow,d"
            "$mod SHIFT,h,movewindow,l"
            "$mod SHIFT,l,movewindow,r"
            "$mod SHIFT,k,movewindow,u"
            "$mod SHIFT,j,movewindow,d"
            "$mod,left,movefocus,l"
            "$mod,right,movefocus,r"
            "$mod,up,movefocus,u"
            "$mod,down,movefocus,d"
            "$mod,h,movefocus,l"
            "$mod,l,movefocus,r"
            "$mod,k,movefocus,u"
            "$mod,j,movefocus,d"
            "$mod SHIFT,SPACE,movetoworkspace,special"
            "$mod,SPACE,togglespecialworkspace"
            "$mod,period,workspace,e+1"
            "$mod,comma,workspace,e-1"
            "$mod,mouse_down,workspace,e+1"
            "$mod,mouse_up,workspace,e-1"
            "ALT,Tab,cyclenext"
            "ALT,Tab,bringactivetotop"
          ]
          ++ (
            ### Workspaces
            # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = i + 1;
                in
                [
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              ) 9
            )
          );

        ### Mouse movement bindings
        bindm = [
          "$mod,mouse:272,movewindow"
          "$mod,mouse:273,resizewindow"
        ];

        ### Hardware keys: resist trigger inhibition
        bindip = [
          ",XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioPlay,exec,playerctl play-pause"
          ",XF86AudioPause,exec,playerctl play-pause"
          ",XF86AudioNext,exec,playerctl next"
          ",XF86AudioPrev,exec,playerctl previous"
        ];

        ### Hardware keys: resist trigger inhibition, can repeat if held
        bindeip = [
          ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
          ",XF86MonBrightnessUp,exec,brightnessctl set +5%"
        ];
      };
    };
  };
}
