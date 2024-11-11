{ pkgs, ... }:
{
  config = {
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
    environment.systemPackages = [ pkgs.libsecret ];
    hardware.gpgSmartcards.enable = true; # Adds udev rules only
    security = {
      rtkit.enable = true;
      polkit = {
        enable = true;
        extraConfig = ''
          polkit.addRule(function(action, subject) {
            if (
              subject.isInGroup("users")
                && (
                  action.id == "org.freedesktop.login1.reboot" ||
                  action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                  action.id == "org.freedesktop.login1.power-off" ||
                  action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                )
              )
            {
              return polkit.Result.YES;
            }
          })
        '';
      };
    };
  };
}
