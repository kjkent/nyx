{
  pkgs,
  config,
  ...
}:
{
  config = {
    boot = {
      blacklistedKernelModules = [ "nouveau" ];
      extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
      initrd.kernelModules = [
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
      ];
    };
    environment.sessionVariables = {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          nvidia-container-toolkit
          vulkan-tools
          libva-utils
        ];
      };
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false; # For dual-GPU systems
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest; # .stable, .beta, .production
      };
    };
  };
}
