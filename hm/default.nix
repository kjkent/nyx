{osConfig, ...}: {
  imports = [
    ./environment.nix
    ./firefox.nix
    ./git.nix
    ./gpg.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./list-bindings.nix
    ./nix.nix
    ./nvim
    ./rofi.nix
    ./screenshot.nix
    ./styling.nix
    ./swaync.nix
    ./syncthing.nix
    ./term
    ./vscode.nix
    ./waybar.nix
  ];
  config = {
    home.stateVersion = osConfig.system.stateVersion;
    programs.home-manager.enable = true;
  };
}
