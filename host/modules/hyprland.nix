{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  arch = pkgs.stdenv.hostPlatform.system;
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${arch};
in
{
  options = with lib; {
    programs.hyprland = {
      monitors = mkOption {
        type = with types; listOf str;
        default = [ ",preferred,auto,1" ];
      };
    };
    nyx.hyprland.enable = mkOption {
      type = types.bool; 
      default = true;
      description = "Whether to enable Hyprland configuration.";
    };
  };

  config = lib.mkIf (config.nyx.hyprland.enable) {
    # Causes NixOS to configure Electron/CEF apps to run on native Wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1"; 

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${arch}.hyprland;
      portalPackage = inputs.hyprland.packages.${arch}.xdg-desktop-portal-hyprland;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ pkgs.egl-wayland ];
      package = pkgs-unstable.mesa.drivers;
      package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
    };

    xdg.portal = with pkgs; {
      enable = true;
      # https://github.com/NixOS/nixpkgs/issues/160923
      xdgOpenUsePortal = true;
      wlr.enable = true;
      extraPortals = [
        xdg-desktop-portal-gtk
        xdg-desktop-portal
      ];
      configPackages = [
        inputs.hyprland.packages.${arch}.xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-desktop-portal
      ];
    };
  };
}
