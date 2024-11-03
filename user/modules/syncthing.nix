{ user, ... }:
{
  config = {
    services.syncthing = {
      enable = true;
      inherit user;
      dataDir = "/home/${user}";
      configDir = "/home/${user}/.config/syncthing";
    };
  };
}
