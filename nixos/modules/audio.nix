{
  config,
  pkgs,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      pavucontrol
      vlc
      mpv
      imv
      playerctl
      ffmpeg
    ];
    boot = {
      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
      kernelModules = ["v4l2loopback"];
    };
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
