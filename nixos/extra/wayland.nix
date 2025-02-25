{
  config,
  nixosUser,
  ...
}: {
  config = {
    programs = {
      ydotool = {
        enable = true;
        inherit (config.users.users.${nixosUser.username}) group;
      };
    };
  };
}
