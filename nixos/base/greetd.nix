{
  nixosUser,
  pkgs,
  ...
}: {
  config = {
    services.greetd = rec {
      enable = true;
      package = with pkgs.greetd; tuigreet;
      settings = {
        default_session = {
          user = nixosUser.username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet";
        };
      };
    };
  };
}
