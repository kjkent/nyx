{ osConfig, ... }:
{
  imports = [
    ./environment.nix
    ./firefox.nix
    ./foot.nix
    ./git.nix
    ./gpg.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./list-bindings.nix
    ./nvim
    ./rofi.nix
    ./screenshot.nix
    ./shell
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