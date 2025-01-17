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
          sopsFile = ./secrets/nix-netrc;
        };
        sshd-hostKeys = {
          sopsFile = ./secrets/sshd-hostKeys.yaml;
        };
      };
    };
  };
}
