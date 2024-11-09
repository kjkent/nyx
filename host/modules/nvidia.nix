{ pkgs, config, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      nvidia-container-toolkit # Replaces nvidia-docker
    ];
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };
    };
  };
}
