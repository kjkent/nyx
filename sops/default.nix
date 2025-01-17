{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  config = {
    sops = {
      defaultSopsFormat = "yaml"; # or "json"
      secrets = {
        nix-netrc = {
          format = "binary";
          sopsFile = ./secrets/nix-netrc.sops.yaml;
        };
        fonts-berkeleyMono = {
          format = "binary";
          sopsFile = ./secrets/fonts-berkeleyMono.tar.xz.sops.yaml;
        };
        sshd-hostKeys = {
          sopsFile = ./secrets/sshd-hostKeys.yaml.sops.yaml;
        };
      };
    };
  };
}
