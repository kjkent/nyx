{
  config.wayland.windowManager.hyprland.settings = let
    uw = exe: "uwsm app -- ${exe}";
  in {
    "$mod" = "SUPER";
    bind =
      [
        "$mod,Return,exec,${uw "ghostty"}"
        "$mod,B,exec,${uw "firefox"}"
        "$mod,S,exec,${uw "screenshot"}"
        "$mod,O,exec,${uw "obsidian"}"
        "$mod,C,exec,${uw "hyprpicker -a"}"
        "$mod,G,exec,${uw "gimp"}"
        "$mod,F,exec,${uw "thunar"}"
        "$mod,M,exec,${uw "spotify"}"
        "$mod,D,exec,rofi -show drun -run-command \"uwsm app -- {cmd}\""
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
            i: let
              ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9
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
      ",XF86AudioRaiseVolume,exec,wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
      ",XF86MonBrightnessUp,exec,brightnessctl set +5%"
    ];
  };
}
