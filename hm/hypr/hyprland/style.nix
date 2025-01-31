{
  config.wayland.windowManager.hyprland.settings = {
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

    general = {
      gaps_in = 6;
      gaps_out = 8;
      border_size = 2;
      layout = "dwindle";
      resize_on_border = true;
    };
  };
}
