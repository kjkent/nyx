{inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./templates
  ];

  config = {
    sops = {
      defaultSopsFile = ./sops.yaml;

      secrets = {
        protonvpn_openvpn_username.key = "protonvpn/openvpn/username";
        protonvpn_openvpn_password.key = "protonvpn/openvpn/password";
        protonvpn_openvpn_ca_cert.key = "protonvpn/openvpn/ca_cert";
        protonvpn_openvpn_tls_key.key = "protonvpn/openvpn/tls_key";
      };
    };
  };
}
