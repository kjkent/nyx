{
inputs,
lib,
pkgs,
config,
...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;

  # packages built by hyprland - unsure of which 
  hypr-pkgs = inputs.hyprland.packages.${system};
  # nixpkgs used to build hypr, so we can match mesa versions
  nixpkgs-hypr = import inputs.hyprland.inputs.nixpkgs {
    inherit (config.nixpkgs.config) allowUnfree;
    inherit system;
  };

  # rightmost takes precedence -- we want to use hyprland input where
  # possible to benefit from caching (+ presumably update speed)
  hypr = nixpkgs-hypr // hypr-pkgs;
in {
  options = with lib; {
    programs.hyprland = {
      monitors = mkOption {
        type = with types; listOf str;
        default = [",preferred,auto,1"];
      };
    };
  };

  # Despite the overlay, assignments in this file still explicitly use
  # `hypr.<pkg>` as I am not 100% sure if overlays apply within the same file
  config = {
    # Causes NixOS to configure Electron/CEF apps to run on native Wayland
    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages = [
        hypr.hyprland-qtutils
        hypr.hyprland-protocols
        hypr.hyprpicker
        hypr.hyprpolkitagent
      ];
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [pkgs.egl-wayland];
      package = hypr.mesa.drivers;
      package32 = hypr.pkgsi686Linux.mesa.drivers;
    };

    nixpkgs.overlays = [
      # ensures nixos and hyprland using same packages to avoid conflict.
      (post: pre: with hypr; {
        inherit
        hyprland
        hyprland-qtutils
        hyprland-protocols
        hyprpaper
        hyprpicker
        hyprpolkitagent
        mesa
        xdg-desktop-portal-hyprland
        ;
        pkgsi1686Linux.mesa = hypr.pkgsi686Linux.mesa;
      })
    ];

    programs.hyprland = {
      enable = true;
      package = hypr.hyprland;
      portalPackage = hypr.xdg-desktop-portal-hyprland;
      withUWSM = true;
    };

    xdg.portal = let
      portals = [
        hypr.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
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
