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
      monitor = mkOption {
        type = types.lines;
        default = "monitor=,preferred,auto,1";
      };
    };
    _.hyprland.enable = mkOption {
      type = types.bool; 
      default = true;
      description = "Whether to enable Hyprland configuration.";
    };
  };

  config = lib.mkIf (config._.hyprland.enable) {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${arch}.hyprland;
      portalPackage = inputs.hyprland.packages.${arch}.xdg-desktop-portal-hyprland;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
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
