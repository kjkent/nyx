{osConfig, ...}: {
  imports = [
    ./environment.nix
    ./firefox.nix
    ./git.nix
    ./gnupg
    ./hypr
    ./nix.nix
    ./nvim
    ./rofi.nix
    ./screenshot.nix
    ./styling.nix
    ./sway.nix
    ./swaync.nix
    ./term
    ./vscode.nix
    ./waybar.nix
  ];

  config = {
    home.stateVersion = osConfig.system.stateVersion;
    programs.home-manager.enable = true;
  };
}
