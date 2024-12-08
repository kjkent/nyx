# largely yoinked (i.e., full credit to) https://github.com/selfuryon/nixos-config/blob/main/nixos/roles/user/desktop/common/waybar.nix

{
  config,
  pkgs,
  ...
}: let
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  hostname = "${pkgs.nettools}/bin/hostname";
  curl = "${pkgs.curl}/bin/curl";
  jq = "${pkgs.jq}/bin/jq";
  cat = "${pkgs.coreutils}/bin/cat";
  cut = "${pkgs.coreutils-full}/bin/cut";

  checkNixosUpdates = pkgs.writeShellScript "checkUpdates.sh" ''
    UPDATE='{"text": "Update", "alt": "update", "class": "update"}'
    NO_UPDATE='{"text": "No Update", "alt": "noupdate", "class": "noupdate"}'

    GITHUB_URL="https://api.github.com/repos/NixOS/nixpkgs/git/refs/heads/nixos-unstable"
    #CURRENT_REVISION=$(nixos-version --revision)
    CURRENT_REVISION=$(${cat} /run/current-system/nixos-version | ${cut} -d. -f4)
    REMOTE_REVISION=$(${curl} -s $GITHUB_URL | ${jq} '.object.sha' -r )
    [[ $CURRENT_REVISION == ''${REMOTE_REVISION:0:7} ]] && echo $NO_UPDATE || echo $UPDATE
  '';
in {
  programs.waybar = {
    enable = true;
    settings = {
      primary = {
        layer = "top";
        height = 40;
        margin = "6";
        position = "top";
        modules-left = [
          "custom/nixos"
          "tray"
          "idle_inhibitor"
          "mpris"
          "hyprland/submap"
        ];
        modules-center = ["hyprland/workspaces"];
        modules-right = ["network" "wireplumber" "battery" "clock" "custom/hostname"];

        "hyprland/workspaces" = {format = "{name}";};
        "hyprland/submap" = {
          format = "󱋜 {}";
          max-length = 8;
        };
        "custom/nixos" = {
          exec = checkNixosUpdates;
          on-click = checkNixosUpdates;
          return-type = "json";
          format = "{icon}";
          format-icons = {
            update = "";
            noupdate = "";
          };
          interval = 10800;
        };
        clock = {
          format = "󱑌  {:%H:%M}";
          format-alt = "󰸗 {:%d %B %Y (%R)}";
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
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        wireplumber = {
          format = "  {volume}%";
          format-muted = "󰝟  0%";
          on-click = pavucontrol;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        battery = {
          bat = "BAT0";
          interval = 40;
          states = {
            warning = 30;
            critical = 15;
          };
          format-icons = ["󱊡" "󱊢" "󱊣"];
          format = "{icon} {capacity}%";
          format-charging = "󱊥 {capacity}%";
        };
        network = {
          interval = 3;
          format-wifi = "   {essid}";
          format-ethernet = "󰈀  Connected";
          format-disconnected = "";
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
          on-click = "";
        };
        "custom/hostname" = {exec = "echo $USER@$(${hostname})";};
        mpris = {
          format = "{player_icon}";
          format-paused = "{status_icon}";
          format-stopped = "{status_icon}";
          player-icons = {
            default = "";
            firefox = "";
          };
          status-icons = {
            paused = "󰏦";
            stopped = "󰙧";
          };
        };
      };
    };
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
        font-family: "BerkeleyMono Nerd Font";
        font-size: 12pt;
        padding: 0 8px;
      }
      .modules-right {
        margin-right: -15px;
      }
      .modules-left {
        margin-left: -15px;
      }

      .modules-left:nth-child(1) {
        background-color: @mauve 
      }
      .modules-left:nth-child(2) {
        background-color: @red
      }
      .modules-left:nth-child(3) {
        background-color: @maroon
      }
      .modules-left:nth-child(4) {
        background-color: @peach
      }
      .modules-left:nth-child(5) {
        backround-color: @yellow
      }

      .modules-right:nth-child(1) {
        background-color: @teal 
      }
      .modules-right:nth-child(2) {
        background-color: @sky
      }
      .modules-right:nth-child(3) {
        background-color: @sapphire
      }
      .modules-right:nth-child(4) {
        background-color: @blue
      }
      .modules-right:nth-child(5) {
        backround-color: @lavender
      }

      window#waybar {
        opacity: 0.90;
        color: @crust;
        padding: 2px;
        background-color: @mantle;
        border-radius: 5px 20px 5px;
      }
      
      #workspaces * {
        padding: 0 4px;
      }
      #workspaces button {
        color: @text;
        border-radius: 0px;
        margin: 4px 2px;
        border-bottom: 4px solid @mauve;
      }
      #workspaces button.hidden {
        background-color: @mantle;
        color: @surface2;
      }
      #workspaces button.focused,
      #workspaces button.active {
        border-bottom: 4px solid @sky;
      }
      #battery.warning {
        background: @peach;
      }
      #battery.critical {
        background: @red;
        color: @mantle;
      }
      #tray {
        color: @text;
      }
    '';
  };
}

