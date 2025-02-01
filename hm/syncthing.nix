{
  config,
  hostName,
  lib,
  ...
}: {
  config = {
    home.file = with config.sops.secrets; {
      ".config/syncthing/cert.pem".source = "syncthing_cert_${hostName}".path;
      ".config/syncthing/key.pem".source = "syncthing_key_${hostName}".path;
    };

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

    sops.secrets = {
      # maps flat dictionary in Nix to nested secret in sops.yaml
      syncthing_cert_${hostName}.key = "syncthing/cert/${hostName}";
      syncthing_key_${hostName}.key = "syncthing/cert/${hostName}";
    };

    systemd.user.services.syncthing = {
      Unit.After = ["sops-nix.service"];
    };
  };
}
