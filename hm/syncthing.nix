{config, lib, osConfig, ...}: {
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
    systemd.user.services.syncthing = {
      Unit.After = lib.mkIf (osConfig ? sops) [ "sops-nix.service" ];
    };
  };
}
