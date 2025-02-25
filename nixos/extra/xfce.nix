_: {
  services = {
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      desktopManager = {
        xfce.enable = true;
      };
    };
  };
}
