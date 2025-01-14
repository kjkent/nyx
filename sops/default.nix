{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  config = {
    sops = {
      defaultSopsFormat = "yaml"; # or "json"
      secrets = {
        attic_netrc = {
          format = "binary";
          sopsFile = ./secrets/attic_netrc.sops;
        };
      };
    };
  };
}
