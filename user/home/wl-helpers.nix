{ config, pkgs, ... }:
let
  flake = "${config.xdg.configHome}/nyx/";
in
{
  config.home.packages = [
    (pkgs.writeShellScriptBin "wl-pick-emoji" ''
      # Get user selection via wofi from emoji file.
      chosen=$(cat $HOME/.config/.emoji | ${pkgs.rofi-wayland}/bin/rofi -i -dmenu -config ~/.config/rofi/config-emoji.rasi | awk '{print $1}')

      # Exit if none chosen.
      [ -z "$chosen" ] && exit

      # If you run this command with an argument, it will automatically insert the
      # character. Otherwise, show a message that the emoji has been copied.
      if [ -n "$1" ]; then
      ${pkgs.ydotool}/bin/ydotool type "$chosen"
      else
          printf "$chosen" | ${pkgs.wl-clipboard}/bin/wl-copy
      ${pkgs.libnotify}/bin/notify-send "'$chosen' copied to clipboard." &
      fi
    '')

    (pkgs.writeShellScriptBin "screenshot" ''
      grim -g "$(slurp)" - | swappy -f -
    '')

    (pkgs.writeShellScriptBin "wl-task-waybar" ''
      sleep 0.1
      ${pkgs.swaynotificationcenter}/bin/swaync-client -t &
    '')

    (pkgs.writeShellScriptBin "rofi-launcher" ''
      if pgrep -x "rofi" > /dev/null; then
        # Rofi is running, kill it
        pkill -x rofi
        exit 
      fi
      rofi -show drun
    '')

    (pkgs.writeShellScriptBin "nyx" ''
      if [ "$1" = "rb" ]; then
        if [ -n "$2" ]; then
          sudo nixos-rebuild switch --flake ${flake}#"$2"
        else
          sudo nixos-rebuild switch --flake ${flake}
        fi
      elif [ "$1" = "up" ]; then
        nix flake update --flake ${flake}
      elif [ "$1" = "cd" ]; then
        cd ${flake}
        $SHELL
      else
        echo ""
        echo "Usage: nyx <command> [options]"
        echo ""
        echo "Commands:"
        echo ""
        echo "rb: Rebuild Nyx"
        echo "    Options: <hostname>"
        echo ""
        echo "up: Update Nyx"
        echo ""
        echo "cd: Change to flake directory"
        echo ""
      fi
    '')
  ];
}
