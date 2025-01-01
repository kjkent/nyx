{
  pkgs,
  config,
  ...
}: {
  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      extraConfig = {
        modi = "drun,filebrowser,run";
        show-icons = true;
        icon-theme = "Papirus";
        location = 0;
        drun-display-format = "{icon} {name}";
        display-drun = " Apps";
        display-run = " Run";
        display-filebrowser = " File";
      };
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        window = {
          width = mkLiteral "33%";
          transparency = "real";
          orientation = mkLiteral "vertical";
          border = mkLiteral "2px";
          border-radius = mkLiteral "20px";
        };
        mainbox = {
          padding = mkLiteral "10px";
          enabled = true;
          orientation = mkLiteral "vertical";
          children = map mkLiteral [
            "inputbar"
            "listbox"
          ];
        };
        inputbar = {
          enabled = true;
          padding = mkLiteral "10px";
          margin = mkLiteral "10px";
          border-radius = "25px";
          orientation = mkLiteral "horizontal";
          children = map mkLiteral [
            "entry"
            "dummy"
            "mode-switcher"
          ];
        };
        entry = {
          enabled = true;
          expand = false;
          width = mkLiteral "18%";
          padding = mkLiteral "5px";
          border-radius = mkLiteral "12px";
          cursor = mkLiteral "text";
          placeholder = "🖥️ Search ";
        };
        listbox = {
          spacing = mkLiteral "5px";
          padding = mkLiteral "5px";
          orientation = mkLiteral "vertical";
          children = map mkLiteral [
            "message"
            "listview"
          ];
        };
        listview = {
          enabled = true;
          columns = 2;
          lines = 6;
          cycle = true;
          dynamic = true;
          scrollbar = false;
          layout = mkLiteral "vertical";
          reverse = false;
          fixed-height = false;
          fixed-columns = true;
          spacing = mkLiteral "5px";
          border = mkLiteral "0px";
        };
        dummy = {
          expand = true;
        };
        mode-switcher = {
          enabled = true;
          spacing = mkLiteral "10px";
        };
        button = {
          width = mkLiteral "5%";
          padding = mkLiteral "5px";
          border-radius = mkLiteral "12px";
          cursor = mkLiteral "pointer";
        };
        scrollbar = {
          width = mkLiteral "4px";
          border = 0;
          handle-width = mkLiteral "8px";
          padding = 0;
        };
        element = {
          enabled = true;
          spacing = mkLiteral "10px";
          padding = mkLiteral "10px";
          border-radius = mkLiteral "12px";
          cursor = mkLiteral "pointer";
        };
        element-icon = {
          size = mkLiteral "20px";
          cursor = mkLiteral "inherit";
        };
        element-text = {
          cursor = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };
        message = {
          border = mkLiteral "0px";
        };
        textbox = {
          padding = mkLiteral "5px";
          border-radius = mkLiteral "5px";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };
        error-message = {
          padding = mkLiteral "5px";
          border-radius = mkLiteral "20px";
        };
      };
    };
  };
}
