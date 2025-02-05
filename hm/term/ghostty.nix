{
  config,
  osConfig,
  pkgs,
  ...
}: {
  config = {
    programs = {
      ghostty = {
        enable = true;
        clearDefaultKeybinds = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        installVimSyntax = true;
        package = pkgs.unstable.ghostty;
        settings = {
          background-opacity = osConfig.stylix.opacity.terminal; # 0..1
          copy-on-select = false;
          cursor-click-to-move = true; # alt-click to jump to mouse!
          focus-follows-mouse = true;
          font-family = [
            # order of precedence
            "Berkeley Mono"
            "Symbols Nerd Font"
            "Blobmoji" # uses noto by default
          ];
          keybind = [
            "ctrl+t>c=new_tab"
            "ctrl+t>p=previous_tab"
            "ctrl+t>n=next_tab"
            "ctrl+t>/=last_tab"

            "ctrl+s>s=new_split:auto"
            "ctrl+s>h=new_split:left"
            "ctrl+s>j=new_split:down"
            "ctrl+s>k=new_split:up"
            "ctrl+s>l=new_split:right"
            "ctrl+s>e=equalize_splits"
            "ctrl+shift+s=toggle_split_zoom"

            "ctrl+h=goto_split:left"
            "ctrl+j=goto_split:bottom"
            "ctrl+k=goto_split:top"
            "ctrl+l=goto_split:right"

            "ctrl+q=close_surface"
            "ctrl+shift+q=close_all_windows"

            "ctrl+shift+c=copy_to_clipboard"
            "ctrl+shift+v=paste_from_clipboard"
            "ctrl+shift+p=paste_from_selection"

            "ctrl+]=scroll_page_up"
            "ctrl+[=scroll_page_down"
          ];
          scrollback-limit = 314572800; # 300MiB
          title = "👻";
          theme = "spaceduck";
          window-decoration = false;
          window-padding-x = 10;
          window-padding-y = 10;
          window-padding-balance = true;
          window-padding-color = "background"; # "extend" or "background"
        };
        themes = {
          catppuccin-mocha = {
            background = "1e1e2e";
            cursor-color = "f5e0dc";
            foreground = "cdd6f4";
            palette = [
              "0=#45475a"
              "1=#f38ba8"
              "2=#a6e3a1"
              "3=#f9e2af"
              "4=#89b4fa"
              "5=#f5c2e7"
              "6=#94e2d5"
              "7=#bac2de"
              "8=#585b70"
              "9=#f38ba8"
              "10=#a6e3a1"
              "11=#f9e2af"
              "12=#89b4fa"
              "13=#f5c2e7"
              "14=#94e2d5"
              "15=#a6adc8"
            ];
            selection-background = "353749";
            selection-foreground = "cdd6f4";
          };
          spaceduck = {
            background = "0f111b";
            cursor-color = "ecf0c1";
            foreground = "ecf0c1";
            palette = [
              "0=000000"
              "1=e33400"
              "2=5ccc96"
              "3=b3a1e6"
              "4=00a3cc"
              "5=ce6f8f"
              "6=7a5ccc"
              "7=686f9a"
              "8=686f9a"
              "9=e33400"
              "10=5ccc96"
              "11=b3a1e6"
              "12=00a3cc"
              "13=ce6f8f"
              "14=7a5ccc"
              "15=ecf0c1"
            ];
            selection-background = "686f9a";
            selection-foreground = "ffffff";
          };
        };
      };
    };
  };
}
