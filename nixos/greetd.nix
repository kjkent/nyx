{
  nixosUser,
  pkgs,
  ...
}: {
  config = {
    environment.etc."greetd/environments".text = ''
      bash
      Hyprland
      startxfce4
      zsh
    '';
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
