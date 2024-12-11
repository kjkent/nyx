{pkgs, osConfig, ...}: let
  swaync = "${pkgs.swaynotificationcenter}/bin/swaync-client";
  transition = "transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);";
  animateBlink = ''
    border-radius: 32%;
    margin: 6px 10px;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: steps(12);
    animation-iteration-count: infinite;
    animation-direction: alternate;
  '';
  moduleColor = side: n: color: ''
    .modules-${side} > widget:nth-child(${builtins.toString n}) > label {
      color: ${color};
    }
  '';
in {
  config = {
    stylix.targets.waybar.enable = false;
    programs.waybar = {
      enable = true;
      settings = {
        primary = {
          layer = "top";
          position = "left";
          margin = "6";
          modules-left = [
            "idle_inhibitor"
            "cpu"
            "memory"
            "disk"
            "wireplumber"
            "mpris"
          ];
          modules-center = ["hyprland/workspaces"];
          modules-right = ["custom/notifications" "tray" "network" "battery" "clock" "custom/exit"];
          "custom/exit" = {
            format = "  ";
            on-click = "loginctl terminate-user 1000";
            tooltip = false;
          };
          "custom/notifications" = {
            tooltip = false;
            format = "{icon} <span foreground='red'>{}</span>";
            format-icons = {
              notification = "";
              none = "";
              dnd-notification = "󰪓";
              dnd-none = "󰪓";
            };
            return-type = "json";
            exec-if = "which ${swaync}";
            exec = "${swaync} -swb";
            on-click = "${swaync} -t";
            escape = true;
          };
          "hyprland/workspaces".format = "{name}";
          clock = {
            format = "{:%H:%M}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              on-scroll = 1;
              on-click-right = "mode";
              format = {
                months = "<span color='#ffead3'><b>{}</b></span>";
                days = "<span color='#ecc6d9'><b>{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                today = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
          };
          wireplumber = {
            format = "vol\n{volume}%";
            format-muted = " ";
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "󰅶";
              deactivated = "󰛊";
            };
          };
          memory = {
            interval = 5;
            format = "ram\n{}%";
          };
          cpu = {
            interval = 5;
            format = "cpu\n{usage:2}%";
          };
          disk = {
            interval = 60;
            format = "hdd\n{percentage_used}%";
          };
          battery = {
            states = {
              warning = 25;
              critical = 15;
            };
            format-icons = ["󱊡" "󱊢" "󱊣"];
            format = "bat\n{capacity}%";
            format-charging = "chg\n{capacity}%";
          };
          network = {
            interval = 3;
            format-wifi = " ";
            format-ethernet = "󰈀";
            format-disconnected = "󱘖";
            tooltip-format = ''
            {ifname}: {essid}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
            on-click = "";
          };
          mpris = {
            format = "{player_icon}";
            format-paused = "{status_icon}";
            format-stopped = "{status_icon}";
            player-icons = {
              default = "";
              firefox = "";
              spotify = "";
            };
            status-icons = {
              paused = "";
              stopped = "";
            };
          };
        };
      };
      style = ''
      /*
      * Catppuccin Mocha palette
      * Maintainer: rubyowo
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

      @define-color lavender  #b4befe;
      @define-color blue      #89b4fa;
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
        font-family: ${osConfig.stylix.fonts.monospace.name};
        font-size: 10pt;
        padding: 0;
        min-height: 0px;
        margin: 4px 0;
      }

      ${moduleColor "left" 1 "@mauve"}
      ${moduleColor "left" 2 "@red"}
      ${moduleColor "left" 3 "@maroon"}
      ${moduleColor "left" 4 "@peach"}
      ${moduleColor "left" 5 "@yellow"}
      ${moduleColor "left" 6 "@green"}

      ${moduleColor "right" 1 "@teal"}
      ${moduleColor "right" 2 "@sky"}
      ${moduleColor "right" 3 "@sapphire"}
      ${moduleColor "right" 4 "@blue"}
      ${moduleColor "right" 5 "@lavender"}

      window#waybar {
        opacity: 0.90;
        background-color: @mantle;
        border-radius: 6px 24px 6px;
      }

      #custom-exit {
       color: @red;
      }

      #idle_inhibitor.activated {
        color: @red;
        ${animateBlink}

      }
      #idle_inhibitor.deactivated {
        color: @lavender;
      }

      #workspaces button {
        color: @text;
        border-radius: 0px;
        border-bottom: 0px;
        ${transition}
      }
      #workspaces button.focused,
      #workspaces button.active {
        border-left: 6px solid @green;
        ${transition}
      }
      #battery.warning {
        background-color: @peach;
        color: @mantle;
      }
      @keyframes blink {
        to {
          border-radius: 32%;
          margin: 6px 10px;
          background-color: @red;
          color: @mantle;
        }
      }
      #battery.critical:not(.charging) {
        color: @red;
        ${animateBlink}
      }
      '';
    };
  };
}

