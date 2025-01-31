{
  nixosUser,
  pkgs,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      git-crypt
      pam_u2f
      sops
      tpm2-tss
      tpm2-tools
      yubikey-manager
    ];
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
    hardware.gpgSmartcards.enable = true; # Adds udev rules only
    security = {
      rtkit.enable = true; # Allows processes to get scheduling priority
      pam.services.hyprlock = {}; # Required by HM hyprlock module
      # Allows shutdown/reboot over ssh without reauthentication
      polkit.extraConfig = ''
        polkit.addRule(function (action, subject) {
          if (subject.isInGroup("wheel") && [
            "org.freedesktop.login1.reboot",
            "org.freedesktop.login1.reboot-multiple-sessions",
            "org.freedesktop.login1.power-off",
            "org.freedesktop.login1.power-off-multiple-sessions",
          ].indexOf(action.id) !== -1) {
            return polkit.Result.YES;
          }
        });
      '';
    };
    systemd.user.services.pokit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    users.users.${nixosUser.username}.extraGroups = ["wheel"];
  };
}
