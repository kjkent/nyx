{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  config = {
    sops = {
      defaultSopsFormat = "yaml"; # or "json"
      secrets = {
        sshd-hostKeys = {
          sopsFile = ./secrets/sshd-hostKeys.yaml;
        };
      };
    };
  };
}
