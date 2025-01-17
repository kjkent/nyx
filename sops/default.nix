{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./sshd
  ];

  config = {
    sops = {
      defaultSopsFormat = "yaml";
    };
  };
}
