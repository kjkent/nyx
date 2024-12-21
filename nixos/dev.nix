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
      wireshark = {
        enable = true;
        # Otherwise uses wireshark-cli... even though the package looks
        # like it installs wireshark??
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/wireshark.nix
        package = pkgs.wireshark;
      };
    };

    users.users.${nixosUser.username}.extraGroups = [ "adbusers" "wireshark" ];
  };
}
