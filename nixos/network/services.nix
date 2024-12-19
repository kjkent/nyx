{
  config,
  hostName,
  lib,
  nixosUser,
  options,
  ...
}:
{
  imports = [ ./firewall ];
  config = {
    networking = {
      inherit hostName;
      networkmanager.enable = false;
      timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    };

    programs = {
      nm-applet.enable = lib.mkIf config.networking.networkmanager.enable true;
    };

    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      openssh.enable = true;
      resolved = {
        enable = true;
        dnssec = "false"; # Sept 2023: SD devs state implementation is not robust enough.
        dnsovertls = "false"; # +++ Disable prior to LAN DOT/DNSSEC implementation.
        fallbackDns = [
          "1.1.1.1"
          "1.2.2.1"
          "9.9.9.9"
        ];
      };
    };

    users.users.${nixosUser.username}.extraGroups = [
      "dialout"
      "networkmanager"
    ];
  };
}
