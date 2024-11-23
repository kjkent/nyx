{ creds, pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [ greetd.tuigreet ];
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = creds.username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };
  };
}
