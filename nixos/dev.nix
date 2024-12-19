{ nixosUser, pkgs, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      android-studio
      dfu-util
      docker-compose
      biome
      bruno
      jetbrains.pycharm-community-bin
      jetbrains.webstorm
      git
      meson
      ninja
      nixd
      neovide
      opentofu
      shellcheck
      tinyxxd # xxd (usually bundled with vim)
      uv
    ];

    programs = {
      adb.enable = true;
      direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
      };
      wireshark.enable = true;
    };

    users.users.${nixosUser.username}.extraGroups = [ "adbusers" "wireshark" ];
  };
}
