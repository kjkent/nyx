{
  lib,
  pkgs,
  config,
  hyprland,
  ...
}:
let
  arch = pkgs.stdenv.hostPlatform.system;
  # pkgs-hypr == os nixpkgs used to build hypr, so we can match versions
  pkgs-hypr = hyprland.inputs.nixpkgs.legacyPackages.${arch};
  # hypr-pkgs == packages for hyprland itself
  hypr-pkgs = hyprland.packages.${arch};
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

  config = lib.mkIf config.nyx.hyprland.enable {
    # Causes NixOS to configure Electron/CEF apps to run on native Wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.hyprland = {
      enable = true;
      package = hypr-pkgs.hyprland;
      portalPackage = hypr-pkgs.xdg-desktop-portal-hyprland;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ pkgs.egl-wayland ];
      package = pkgs-hypr.mesa.drivers;
      package32 = pkgs-hypr.pkgsi686Linux.mesa.drivers;
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
        hypr-pkgs.xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-desktop-portal
      ];
    };
  };
}
