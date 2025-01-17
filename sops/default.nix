{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  config = {
    sops = {
      defaultSopsFormat = "yaml"; # or "json"
      # Format: secrets.<key_name>.sopsFile = <e.g YAML file in which key_name present at top level, val must be str>
      #secrets = {};
    };
  };
}
