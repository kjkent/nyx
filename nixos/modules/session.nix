{
  user,
  pkgs,
  ...
}:
{
  config = {
    services.greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          inherit user;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };
  };
}
