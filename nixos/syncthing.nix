{
  config,
  hostName,
  lib,
  nixosUser,
  ...
}: {
  config = let
    userHome = "/home/${nixosUser.username}";
    configDir = "${userHome}/.config/syncthing";
  in {
    services = {
      syncthing = {
        enable = true;
        inherit configDir;
        key = config.sops.secrets."syncthing_key_${hostName}".path;
        cert = config.sops.secrets."syncthing_cert_${hostName}".path;
        databaseDir = "${userHome}/.local/share/syncthing";
        dataDir = userHome;
        extraFlags = [
          "--no-default-folder"
        ];
        group = nixosUser.username;
        openDefaultPorts = true;
        overrideFolders = false; # remove these overrides when configured in nix
        overrideDevices = false;
        settings = {
          relaysEnabled = true;
          options = {
            urAccepted = -1; # usage reporting disabled
          };
        };
        user = nixosUser.username;
      };
    };
    sops.secrets = let
      owner = nixosUser.username;
      restartUnits = ["syncthing.service"];
    in {
      "syncthing_cert_${hostName}" = {
        inherit owner restartUnits;
        key = "syncthing/cert/${hostName}";
      };
      "syncthing_key_${hostName}" = {
        inherit owner restartUnits;
        key = "syncthing/key/${hostName}";
      };
    };
    systemd.services.syncthing.after = ["sops-nix.service"];
  };
}
