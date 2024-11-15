{ stateVersion, ... }:
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
    ./neovim.nix
    ./rofi.nix
    ./screenshot.nix
    ./starship.nix
    ./styling.nix
    ./swaync.nix
    ./syncthing.nix
    ./waybar.nix
    ./wlogout.nix
    ./zsh.nix
  ];
  config = {
    home = {
      inherit stateVersion;
    };
    programs.home-manager.enable = true;
  };
}
