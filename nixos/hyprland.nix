{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;

  # See: https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/

  # contains hyprland and xdg-desktop-portal-hyprland
  # https://github.com/hyprwm/Hyprland/blob/ef03f6911694413b1b06aba727ad9ab089a511f7/flake.nix#L128
  hyprPkgs = inputs.hyprland.packages.${system};
  # references nixpkgs unstable
  nixpkgs-hypr = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system};
in {
  options = with lib; {
    programs.hyprland = {
      monitors = mkOption {
        type = with types; listOf str;
        default = [",preferred,auto,1"];
      };
    };
  };

  config = with pkgs; {
    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      # use hyprland's nixpkgs-unstable commit for mesa to ensure version match
      package = nixpkgs-hypr.mesa.drivers;
      package32 = nixpkgs-hypr.pkgsi686Linux.mesa.drivers;
    };

    programs = {
      hyprland = with hyprPkgs; {
        enable = true;
        package = hyprland;
        portalPackage = xdg-desktop-portal-hyprland;
      };
    };
    xdg.portal = let
      portals = [
        hyprPkgs.xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    in {
      configPackages = portals;
      config.common.default = "hyprland";
      enable = true;
      extraPortals = portals;
      # https://github.com/NixOS/nixpkgs/issues/160923
      xdgOpenUsePortal = true;
    };
  };
}
