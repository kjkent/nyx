{
config,
hostName,
lib,
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
        key = config.sops.secrets."syncthing_key_${hostName}".path;
        cert = config.sops.secrets."syncthing_cert_${hostName}".path;
        databaseDir = "${userHome}/.local/share/syncthing";
        dataDir = userHome;
        extraFlags = ["--no-default-folder"];
        group = nixosUser.username;
        openDefaultPorts = true;
        overrideFolders = true;
        overrideDevices = true;
        settings = let
          devices = import "${self}/hosts/shared/syncthing/devices.nix" {inherit hostName lib;};
          folders = import "${self}/hosts/shared/syncthing/folders.nix" {inherit hostName lib;};
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
