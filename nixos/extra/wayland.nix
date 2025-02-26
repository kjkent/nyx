{
  config,
  nixosUser,
  pkgs,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      wev # wayland event viewer; xev equivalent
    ];
    programs = {
      ydotool = {
        enable = true;
        inherit (config.users.users.${nixosUser.username}) group;
      };
    };
  };
}
