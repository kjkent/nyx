{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  clock24h = true;
in
with lib;
{
  config = {
    
    # Configure & Theme Waybar
    programs.waybar = {
      enable = true;
      settings = [
        {
          layer = "top";
          position = "top";
          modules-center = [ "hyprland/workspaces" ];
          modules-left = [
            "idle_inhibitor"
            "pulseaudio"
            "cpu"
            "memory"
            "disk"
            "custom/music"
          ];
          modules-right = [
            "custom/notification"
            "battery"
            "tray"
            "clock"
            "custom/exit"
          ];

          "hyprland/workspaces" = {
            format = "{name}";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };
          clock = {
            format = if clock24h then '' {:L%H:%M}'' else '' {:L%I:%M %p}'';
            tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
          };
          memory = {
            interval = 5;
            format = " {}%";
          };
          cpu = {
            interval = 5;
            format = " {usage:2}%";
          };
          disk = {
            format = " {percentage_used}";
          };
          network = {
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            format-ethernet = " {bandwidthDownOctets}";
            format-wifi = "{icon}{signalStrength}%";
            format-disconnected = "󰤮";
          };
          tray = {
            icon-size = 21;
            spacing = 10;
          };
          "custom/music" = {
            format = "  {}";
            escape = true;
            interval = 5;
            tooltip = false;
            exec = "${pkgs.playerctl}/bin/playerctl metadata --format='{{ title }}'";
            on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
            max-length = 50;
          };
          pulseaudio = {
            format = "{icon} {volume}% {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = "󰝟 {icon} {format_source}";
            format-muted = "󰝟 {format_source}";
            format-source = "  {volume}%";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "pavucontrol";
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "󰈈";
              deactivated = "󰒲";
            };
          };
          backlight = {
            device = "intel_backlight";
            format = "{icon}";
            format-icons = ["" "" "" "" "" "" "" "" ""];
          }; 
          "custom/exit" = {
            on-click = "loginctl terminate-seat seat0";
            format = "󰩈";
          };
          "custom/notification" = {
            format = "{icon} {}";
            format-icons = {
              notification = " <span foreground='red'><sup></sup></span>";
              none = "";
              dnd-notification = "󰪓 <span foreground='red'><sup></sup></span>";
              dnd-none = "󰪓";
              inhibited-notification = " <span foreground='red'><sup></sup></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "󰪓 span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "󰪓";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "sleep 0.1 && wl-task-waybar";
            escape = true;
          };
          battery = {
            states = {
              warning = 20;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󱘖 {capacity}%";
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
        }
      ];
      style = ''
        /*
        *
        * Catppuccin Mocha palette
        * Maintainer: rubyowo
        *
        */
        
        @define-color base   #1e1e2e;
        @define-color mantle #181825;
        @define-color crust  #11111b;
        
        @define-color text     #cdd6f4;
        @define-color subtext0 #a6adc8;
        @define-color subtext1 #bac2de;
        
        @define-color surface0 #313244;
        @define-color surface1 #45475a;
        @define-color surface2 #585b70;
        
        @define-color overlay0 #6c7086;
        @define-color overlay1 #7f849c;
        @define-color overlay2 #9399b2;
        
        @define-color blue      #89b4fa;
        @define-color lavender  #b4befe;
        @define-color sapphire  #74c7ec;
        @define-color sky       #89dceb;
        @define-color teal      #94e2d5;
        @define-color green     #a6e3a1;
        @define-color yellow    #f9e2af;
        @define-color peach     #fab387;
        @define-color maroon    #eba0ac;
        @define-color red       #f38ba8;
        @define-color mauve     #cba6f7;
        @define-color pink      #f5c2e7;
        @define-color flamingo  #f2cdcd;
        @define-color rosewater #f5e0dc;
        
        * {
          font-family: BerkeleyMono Nerd Font;
          font-size: 17px;
          min-height: 0;
        }
        
        #waybar {
          background: transparent;
          color: @text;
          margin: 5px 5px;
        }
        
        #workspaces {
          border-radius: 1rem;
          margin: 5px;
          background-color: @surface0;
          margin-left: 1rem;
        }
        
        #workspaces button {
          color: @lavender;
          border-radius: 1rem;
          padding: 0.4rem;
        }
        
        #workspaces button.active {
          color: @sky;
          border-radius: 1rem;
        }
        
        #workspaces button:hover {
          color: @sapphire;
          border-radius: 1rem;
        }
        
        #custom-music,
        #tray,
        #backlight,
        #clock,
        #battery,
        #pulseaudio,
        #custom-lock,
        #custom-power {
          background-color: @surface0;
          padding: 0.5rem 1rem;
          margin: 5px 0;
        }
        
        #clock {
          color: @blue;
          border-radius: 0px 1rem 1rem 0px;
          margin-right: 1rem;
        }
        
        #battery {
          color: @green;
        }
        
        #battery.charging {
          color: @green;
        }
        
        #battery.warning:not(.charging) {
          color: @red;
        }
        
        #backlight {
          color: @yellow;
        }
        
        #backlight, #battery {
            border-radius: 0;
        }
        
        #pulseaudio {
          color: @maroon;
          border-radius: 1rem 0px 0px 1rem;
          margin-left: 1rem;
        }
        
        #custom-music {
          color: @mauve;
          border-radius: 1rem;
        }
        
        #custom-lock {
            border-radius: 1rem 0px 0px 1rem;
            color: @lavender;
        }
        
        #custom-power {
            margin-right: 1rem;
            border-radius: 0px 1rem 1rem 0px;
            color: @red;
        }
        
        #tray {
          margin-right: 1rem;
          border-radius: 1rem;
        }
      '';
    };
    home.packages = [
      (pkgs.writeShellScriptBin "wl-task-waybar" ''
        sleep 0.1
        ${pkgs.swaynotificationcenter}/bin/swaync-client -t &
      '')
    ];
  };
}
