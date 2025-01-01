{config, ...}: {
  config = {
    services = {
      syncthing = {
        enable = true;
        tray = false;
        extraOptions = [
          "--data=${config.xdg.dataHome}/syncthing"
          "--config=${config.xdg.configHome}/syncthing"
          "--no-default-folder"
          "--allow-newer-config"
        ];
      };
    };
  };
}
