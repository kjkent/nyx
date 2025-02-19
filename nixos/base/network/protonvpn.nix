{config, lib, pkgs, ...}: let
  block = 0; # 1: malware. 2: malware + ads. anything else: disabled
  moderateNat = false; # strict NAT by default
in {
  config = {
    environment.etc.openvpn.source = "${pkgs.update-systemd-resolved}/libexec/openvpn";

    services = {
      openvpn = {
        servers = {
          protonvpn = {
            autoStart = false;
            config = "config ${config.sops.templates.protonvpn_CH_ovpn.path}";
          };
        };
      };
    };

    sops = {
      secrets = {
        # maps flat dictionary in Nix to nested secret in sops.yaml
        protonvpn_openvpn_username.key = "protonvpn/openvpn/username";
        protonvpn_openvpn_password.key = "protonvpn/openvpn/password";
        protonvpn_openvpn_ca_cert.key = "protonvpn/openvpn/ca_cert";
        protonvpn_openvpn_tls_key.key = "protonvpn/openvpn/tls_key";
      };

      templates.protonvpn_CH_ovpn.content = let
        getSecret = id:
          lib.attrsets.attrByPath
          ["protonvpn_openvpn_${id}"] ''¯\_(ツ)_/¯''
          config.sops.placeholder;

        suffix = {
          block = if block == 1 then "+f1" else if block == 2 then "+f2" else "";
          nat = if moderateNat then "+nr" else "";
        };

        username = (getSecret "username") + suffix.block + suffix.nat;
      in ''
        client
        dev tun
        proto udp

        remote 146.70.226.226 4569
        remote 185.159.157.13 4569
        remote 138.199.6.179 80
        remote 146.70.226.194 51820
        remote 149.88.27.193 4569
        remote 149.88.27.193 1194
        remote 149.88.27.233 5060
        remote 185.159.157.129 51820
        remote 146.70.226.226 5060
        remote 185.230.125.34 5060
        remote 185.159.157.129 5060
        remote 149.88.27.206 51820
        remote 146.70.226.226 51820
        remote 185.159.157.129 80
        remote 149.88.27.234 4569
        remote 185.230.125.2 4569
        remote 149.88.27.193 51820
        remote 146.70.226.194 4569
        remote 149.88.27.206 1194
        remote 185.159.157.129 1194
        remote 146.70.226.194 80
        remote 138.199.6.179 4569
        remote 185.230.125.2 51820
        remote 149.88.27.233 4569
        remote 185.230.125.34 80
        remote 149.88.27.234 80
        remote 146.70.226.226 80
        remote 185.230.125.2 1194
        remote 138.199.6.179 1194
        remote 79.127.184.1 1194
        remote 185.159.157.13 5060
        remote 149.88.27.233 51820
        remote 146.70.226.226 1194
        remote 185.230.125.34 4569
        remote 79.127.184.1 4569
        remote 149.88.27.233 1194
        remote 185.230.125.2 5060
        remote 79.127.184.1 51820
        remote 185.159.157.13 51820
        remote 79.127.184.1 80
        remote 149.88.27.233 80
        remote 146.70.226.194 1194
        remote 185.159.157.129 4569
        remote 146.70.226.194 5060
        remote 149.88.27.234 51820
        remote 149.88.27.193 5060
        remote 149.88.27.193 80
        remote 185.230.125.2 80
        remote 185.159.157.13 80
        remote 149.88.27.206 4569
        remote 149.88.27.234 5060
        remote 185.230.125.34 51820
        remote 79.127.184.1 5060
        remote 138.199.6.179 51820
        remote 149.88.27.206 5060
        remote 185.159.157.13 1194
        remote 149.88.27.234 1194
        remote 138.199.6.179 5060
        remote 185.230.125.34 1194
        remote 149.88.27.206 80
        server-poll-timeout 20

        remote-random
        resolv-retry infinite
        nobind

        cipher AES-256-GCM

        setenv CLIENT_CERT 0
        tun-mtu 1500
        mssfix 0
        persist-key
        persist-tun

        reneg-sec 0

        remote-cert-tls server

        <auth-user-pass>
        ${username}
        ${getSecret "password"}
        </auth-user-pass>

        script-security 2
        up /etc/openvpn/update-resolv-conf
        down /etc/openvpn/update-resolv-conf

        fast-io
        sndbuf 512000
        rcvbuf 512000
        txqueuelen 2000

        dhcp-option DOMAIN-ROUTE .

        <ca>
        ${getSecret "ca_cert"}
        </ca>

        <tls-crypt>
        ${getSecret "tls_key"}
        </tls-crypt>
      '';
    };
  };
}
