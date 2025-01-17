{inputs, lib, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  config = let
    mkKeySecret = host: algo: key: with lib.strings; let
      keyVar = if hasPrefix "public" key then "${key}_unencrypted" else key;
    in { 
      "sshd-${host}-${algo}-${keyVar}" = {
        format = "yaml";
        sopsFile = ./sshd_host_keys.yaml;
      };
    };
  in {
    sops.secrets = {}
      // (mkKeySecret "klap" "ed25519" "private")
      // (mkKeySecret "klap" "ed25519" "public")
      // (mkKeySecret "klap" "rsa" "private")
      // (mkKeySecret "klap" "rsa" "public")
      // (mkKeySecret "klap" "rsa" "public_gpg")

      // (mkKeySecret "kdes" "ed25519" "private")
      // (mkKeySecret "kdes" "ed25519" "public")
      // (mkKeySecret "kdes" "rsa" "private")
      // (mkKeySecret "kdes" "rsa" "public")
      // (mkKeySecret "kdes" "rsa" "public_gpg")
    ;
  };
}
