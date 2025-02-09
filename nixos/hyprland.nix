{
  lib,
  pkgs,
  ...
}:
{
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
    };

    programs = {
      hyprland = {
        enable = true;
        package = hyprland;
        portalPackage = xdg-desktop-portal-hyprland;
      };
    };
    xdg.portal = let
      portals = [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    in {
      configPackages = portals;
      config.common.default = "hyprland";
      enable = true;
      extraPortals = portals;
      xdgOpenUsePortal = true;
    };
  };
}
