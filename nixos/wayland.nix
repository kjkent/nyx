{config, nixosUser, pkgs, ...}: {
  config = {
    programs = {
      ydotool = {
        enable = true;
        group = config.users.users.${nixosUser.username}.group;
      };
    };
  };
}
