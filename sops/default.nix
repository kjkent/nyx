{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./templates
  ];

  config = {
    sops = {
      defaultSopsFile = ./sops.yaml;

      secrets = {
        #protonvpn_openvpn_username.key = ''["protonvpn"]["openvpn"]["username"]'';
        protonvpn_openvpn_username.key = "protonvpn/openvpn/username";
      };
    };
  };
}
