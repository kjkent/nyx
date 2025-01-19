{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./templates
  ];

  config = {
    sops = {
      defaultSopsFile = ./sops.yaml
    };
  };
}
