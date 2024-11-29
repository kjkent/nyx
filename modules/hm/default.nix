{ osConfig, ... }:
{
  imports = [
    ./environment.nix
    ./fastfetch.nix
    ./firefox.nix
    ./foot.nix
    ./git.nix
    ./gpg.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./list-bindings.nix
    ./nix-index-db.nix
    ./nvim
    ./rofi.nix
    ./screenshot.nix
    ./shell
    ./starship
    ./styling.nix
    ./swaync.nix
    ./syncthing.nix
    ./waybar.nix
    ./wlogout.nix
  ];
  config = {
    home.stateVersion = osConfig.system.stateVersion;
    programs.home-manager.enable = true;
  };
}
