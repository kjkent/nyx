{
  creds,
  pkgs,
  ...
}: {
  config = {
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
