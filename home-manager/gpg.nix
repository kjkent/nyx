{
  pkgs,
  config,
  gpgKeygrip,
  self,
  ...
}:
{
  config = {
    services.gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableExtraSocket = true;
      enableScDaemon = true;
      enableSshSupport = true;
      defaultCacheTtl = 600;
      defaultCacheTtlSsh = 1800;
      maxCacheTtl = 7200;
      maxCacheTtlSsh = 7200;
      pinentryPackage = pkgs.pinentry-gnome3;
      sshKeys = [ gpgKeygrip ]; # Accepts keygrip of gpg key
      verbose = true;
    };

    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.configHome}/gnupg";
      mutableKeys = true;
      mutableTrust = true;
      scdaemonSettings = {
        pcsc-shared = true;
        disable-ccid = false;
      };
      settings = {
        openpgp = true;
        expert = true;
        trust-model = "tofu+pgp";
        require-cross-certification = true;
        charset = "utf-8";
        auto-key-retrieve = true;
        auto-key-locate = "wkd,dane,local";
        keyserver = "hkps://keyserver.ubuntu.com:443";
        throw-keyids = true;
        armor = true;
        no-symkey-cache = true;
        with-key-origin = true;
        with-fingerprint = true;
        verify-options = "show-uid-validity";
        list-options = "show-uid-validity show-unusable-subkeys";
        keyid-format = "0xlong";
        no-greeting = true;
        no-emit-version = true;
        no-comments = true;
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
        default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed mdc no-ks-modify";
        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";
      };
      publicKeys = [
        {
          source = "${self}/credentials/gpg.pub.asc";
          trust = 5;
        }
      ];
    };
  };
}
