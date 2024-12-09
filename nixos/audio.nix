{ config, pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      ardour
      audacity
      easyeffects
      ffmpeg
      imv
      mpv
      pavucontrol
      playerctl
      spotify
      v4l-utils
      vlc
    ];
    boot = {
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      kernelModules = [ "v4l2loopback" ];
    };
    hardware.pulseaudio.enable = false;
    programs = {
      dconf.enable = true;
    };
    services = {
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };
    };
  };
}
