{
  config,
  lib,
  nixosUser,
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
            "backlight"
            "custom/notifications"
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
            format = " {percentage_used}%";
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
            on-click = "loginctl terminate-user ${builtins.toString osConfig.users.users.${nixosUser.username}.uid}";
            format = " 󰩈 ";
          };
          "custom/notifications" = {
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
        
        label.module, #workspaces button {
          border-radius: 0% 100% 0% 100% / 80%;
          font-family: BerkeleyMono Nerd Font;
          font-size: 18px;
          margin: 0px 6px;
          padding: 0px 4px;
          min-height: 0;
          background-color: @mantle;
        }
        
        window#waybar {
          margin-top: 2px;
          background: transparent;
          color: @text;
        }
        
        #workspaces button {
          color: @lavender;
        }
        
        #workspaces button.active {
          color: @teal;
        }
        
        #workspaces button:hover {
          color: @pink;
        }
        
        #clock {
          color: @blue;
        }
        
        #battery {
          color: @green;
        }

        #cpu {
          color: @maroon;
        }
        #memory {
          color: @peach;
        }
        #disk {
          color: @yellow;
        }
        
        #battery.charging {
          color: @green;
        }

        #idle_inhibitor {
          color: @lavender;
        }

        @keyframes blink {
          to {
            background-color: @red;
            color: @mantle;
          }
        }
        
        #battery.warning:not(.charging) {
          color: @red;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: steps(12);
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }
        
        #backlight {
          color: @sky;
        }
        
        #pulseaudio {
          color: @red;
        }
        
        #custom-music {
          color: @green;
        }

        #custom-notifications {
          color: @sapphire;
        }
        
        #custom-exit {
            color: @mauve;
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
