{ config, pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      easyeffects # needs services.dconf.enable = true;
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
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };
}
