{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  
  # pkgs-hypr == os nixpkgs used to build hypr, so we can match mesa versions
  pkgs-hypr = import inputs.hyprland.inputs.nixpkgs {
    inherit (config.nixpkgs.config) allowUnfree;
    inherit system;
  };

  # hypr-pkgs == packages for hyprland itself
  hypr-pkgs = inputs.hyprland.packages.${system};
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

  config = with pkgs; lib.mkIf config.nyx.hyprland.enable {
    # mesa in pkgs-hypr now replaces/supersedes that in nixpkgs
    nixpkgs.overlays = with inputs; [
      (post: pre: with config.nixpkgs; {
        inherit (pkgs-hypr) mesa;
        pkgsi1686Linux.mesa = pkgs-hypr.pkgsi686Linux.mesa;
        inherit (hypr-pkgs) hyprland xdg-desktop-portal-hyprland;
      })
    ];

    # Causes NixOS to configure Electron/CEF apps to run on native Wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.hyprland = {
      enable = true;
      package = hyprland;
      portalPackage = xdg-desktop-portal-hyprland;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ egl-wayland ];
      package = mesa.drivers;
      package32 = pkgsi686Linux.mesa.drivers;
    };

    xdg.portal = {
      enable = true;
      # https://github.com/NixOS/nixpkgs/issues/160923
      xdgOpenUsePortal = true;
      wlr.enable = true;
      extraPortals = [
        xdg-desktop-portal-gtk
        xdg-desktop-portal
      ];
      configPackages = [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-desktop-portal
      ];
    };
  };
}
