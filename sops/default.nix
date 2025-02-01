{inputs, self, ...}: with inputs.sops-nix; {
  imports = [nixosModules.sops];

  config = {
    sops.defaultSopsFile = ./sops.yaml;
  };
}
