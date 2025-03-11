{
  config,
  lib,
  nixosHost,
  nixosUser,
  self,
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
        key = config.sops.secrets."syncthing_key_${nixosHost}".path;
        cert = config.sops.secrets."syncthing_cert_${nixosHost}".path;
        databaseDir = "${userHome}/.local/share/syncthing";
        dataDir = userHome;
        extraFlags = ["--no-default-folder"];
        group = nixosUser.username;
        openDefaultPorts = true;
        overrideFolders = true;
        overrideDevices = true;
        settings = let
          devices = import "${self}/hosts/shared/syncthing/devices.nix" {inherit nixosHost lib;};
          folders = import "${self}/hosts/shared/syncthing/folders.nix" {inherit nixosHost lib;};
        in {
          inherit devices folders;
          options = {
            urAccepted = -1; # usage reporting disabled
          };
          relaysEnabled = true;
        };
        user = nixosUser.username;
      };
    };

    sops.secrets = let
      owner = nixosUser.username;
      restartUnits = ["syncthing.service"];
    in {
      "syncthing_cert_${nixosHost}" = {
        inherit owner restartUnits;
        key = "syncthing/cert/${nixosHost}";
      };
      "syncthing_key_${nixosHost}" = {
        inherit owner restartUnits;
        key = "syncthing/key/${nixosHost}";
      };
    };

    systemd.services.syncthing.after = ["sops-nix.service"];
  };
}
