{
  config,
  self,
  ...
}:
let
  avatar = "${config.xdg.dataHome}/hyprlock/mr_bones.jpg";
in
{
  config = {
    home.file."${avatar}".source = "${self}/assets/mr_bones.jpg";
    programs = {
      hyprlock = {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = true;
            grace = 10;
            hide_cursor = true;
            no_fade_in = false;
          };
          image = [
            {
              path = "${avatar}";
              size = 150;
              border_size = 4;
              border_color = "rgb(0C96F9)";
              rounding = -1; # Negative means circle
              position = "0, 200";
              halign = "center";
              valign = "center";
            }
          ];
          input-field = [
            {
              size = "200, 50";
              position = "0, -80";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(CFE6F4)";
              inner_color = "rgb(657DC2)";
              outer_color = "rgb(0D0E15)";
              outline_thickness = 5;
              placeholder_text = "Password...";
              shadow_passes = 2;
            }
          ];
        };
      };
    };
    services = {
      hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };
          listener = [
            {
              timeout = 900;
              on-timeout = "hyprlock";
            }
            {
              timeout = 1200;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };
  };
}
