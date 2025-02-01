{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  config = {
    sops = {
      defaultSopsFile = ./sops.yaml;
    };
  };
}
