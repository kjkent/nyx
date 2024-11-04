{ user, ... }:
{
  config = {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      inherit user;
      dataDir = "/home/${user}";
      configDir = "/home/${user}/.config/syncthing";
    };
    # Don't create default ~/Sync folder
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  };
}
