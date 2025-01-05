{pkgs, ...}: {
  config = {
    programs = {
      foot = {
        enable = true;
        settings = {
          main = {
            pad = "10x10 center";
            term = "xterm-256color";
          };
          scrollback = {
            lines = 10000;
          };
          cursor = {
            style = "underline";
            blink = "yes";
          };
          mouse = {
            hide-when-typing = "yes";
          };
        };
      };
    };
  };
}
