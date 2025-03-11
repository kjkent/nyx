{config, lib, pkgs, nixosHost, ...}: let
  wgNetwork = "home";
  wgPubKey = "t2fvs3Feea+eSPCWV5QHCaQ23L+xtCi0AT45XQUbUhA=";
in {
  options = {
    networking.wg-quick.networks.${wgNetwork}.enable = lib.mkEnableOption "${wgNetwork} WireGuard config";
  };

  config = lib.mkIf config.networking.wg-quick.networks.${wgNetwork}.enable {
    networking.wg-quick.interfaces.${wgNetwork} = {
      autostart = false;
      configFile = config.sops.templates."wg_${wgNetwork}_conf".path;
    };
    sops = {
      secrets = {
        # Map sops-nix attr path to sops key path"
        "wireguard_${wgNetwork}_allowed_ips".key = "wireguard/${wgNetwork}/allowed_ips";
        "wireguard_${wgNetwork}_dns".key = "wireguard/${wgNetwork}/dns";
        "wireguard_${wgNetwork}_endpoint".key = "wireguard/${wgNetwork}/endpoint";
        "wireguard_${wgNetwork}_pub_key".key = "wireguard/${wgNetwork}/pub_key";

        "wireguard_${wgNetwork}_peers_${nixosHost}_address".key = "wireguard/${wgNetwork}/peers/${nixosHost}/address";
        "wireguard_${wgNetwork}_peers_${nixosHost}_priv_key".key = "wireguard/${wgNetwork}/peers/${nixosHost}/priv_key";
        "wireguard_${wgNetwork}_peers_${nixosHost}_psk".key = "wireguard/${wgNetwork}/peers/${nixosHost}/psk";
      };
      templates."wg_${wgNetwork}_conf" = {
        content = let
          fallback = ''¯\_(ツ)_/¯'';
          getNetSecret = id: 
            lib.attrsets.attrByPath
            ["wireguard_${wgNetwork}_${id}"] fallback
            config.sops.placeholder;
          getPeerSecret = id: 
            lib.attrsets.attrByPath
            ["wireguard_${wgNetwork}_peers_${nixosHost}_${id}"] fallback
            config.sops.placeholder;
        in ''
          [Interface]
          PrivateKey = ${getPeerSecret "priv_key"}
          Address = ${getPeerSecret "address"}
          DNS = ${getNetSecret "dns"}
          
          [Peer]
          PublicKey = ${wgPubKey}
          PresharedKey = ${getPeerSecret "psk"}
          Endpoint = ${getNetSecret "endpoint"}
          AllowedIPs = ${getNetSecret "allowed_ips"}       
        '';
        path = "/etc/wg/${wgNetwork}.conf";
      };
    };
  };
}
