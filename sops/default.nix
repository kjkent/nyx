{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    #./attic.nix
  ];

  config = {
    sops = {
      defaultSopsFormat = "yaml"; # or "json"
    };
  };
}
