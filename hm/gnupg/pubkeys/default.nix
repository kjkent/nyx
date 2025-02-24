{nixosUser, nixosHosts, self, ...}: let
  hostKeys = map
    (host: {
      source = "${self}/hosts/${host}/ssh_host_rsa_key.gpg.pub";
      trust = 5;
    })
    nixosHosts;
in {
  config = {
    programs.gpg.publicKeys = hostKeys ++ [
      {
        text = nixosUser.gpg.pubKey;
        trust = 5;
      }
      {
        source = ./libreboot.asc;
        trust = 2;
      }
    ];
  };
}
