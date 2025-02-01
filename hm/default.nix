{inputs, osConfig, ...}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./environment.nix
    ./firefox.nix
    ./git.nix
    ./gpg.nix
    ./hypr
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
