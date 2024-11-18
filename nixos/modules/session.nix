{
  user,
  pkgs,
  ...
}: {
  config = {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          inherit user;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };
  };
}
