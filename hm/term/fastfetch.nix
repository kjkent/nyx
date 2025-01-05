{assetsPath, ...}: {
  config = {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "${assetsPath}/nixos.png";
          type = "auto";
          height = 15;
          width = 30;
          padding = {
            top = 3;
            left = 3;
          };
        };
        modules = [
          "break"
          {
            type = "custom";
            format = "┌──────────────────────Hardware──────────────────────┐";
          }
          {
            type = "cpu";
            key = "  ";
          }
          {
            type = "gpu";
            key = "  󰍛";
          }
          {
            type = "memory";
            key = "  󰑭";
          }
          {
            type = "custom";
            format = "└────────────────────────────────────────────────────┘";
          }
          {
            type = "custom";
            format = "┌──────────────────────Software──────────────────────┐";
          }
          {
            type = "kernel";
            key = "  ";
          }
          {
            type = "packages";
            key = "  󰏖";
          }
          {
            type = "shell";
            key = "  ";
          }
          {
            type = "wm";
            key = "  ";
          }
          {
            type = "wmtheme";
            key = "  󰉼";
          }
          {
            type = "terminal";
            key = "  ";
          }
          {
            type = "custom";
            format = "└────────────────────────────────────────────────────┘";
          }
          {
            type = "custom";
            format = "┌────────────────────Uptime / Age────────────────────┐";
          }
          {
            type = "command";
            key = "  ";
            text =
              #bash
              ''
                birth_install=$(stat -c %W /)
                current=$(date +%s)
                delta=$((current - birth_install))
                delta_days=$((delta / 86400))
                echo $delta_days days
              '';
          }
          {
            type = "uptime";
            key = "  ";
          }
          {
            type = "custom";
            format = "└────────────────────────────────────────────────────┘";
          }
          "break"
        ];
      };
    };
  };
}
