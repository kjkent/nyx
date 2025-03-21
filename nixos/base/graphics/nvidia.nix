{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    hardware.nvidia.enable = with lib;
      mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable NVIDIA GPU configuration";
      };
  };
  config = lib.mkIf config.hardware.nvidia.enable {
    boot = {
      blacklistedKernelModules = ["nouveau"];
      extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
      initrd.kernelModules = [
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
      ];
    };
    environment = {
      sessionVariables = {
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        LIBVA_DRIVER_NAME = "nvidia";
        NVD_BACKEND = "direct";
      };
      systemPackages = with pkgs; [
        cudaPackages.cudnn
        cudaPackages.cutensor
      ];
    };

    programs = {
      nix-ld.libraries = with pkgs; [
        nvidia-vaapi-driver
        config.boot.kernelPackages.nvidia_x11
      ];
    };
    services = {
      xserver.videoDrivers = ["nvidia"];
      ollama.acceleration = "cuda";
      tabby.acceleration = "cuda";
    };
    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          config.boot.kernelPackages.nvidia_x11
        ];
      };
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false; # For dual-GPU systems
        open = true;
        nvidiaSettings = true;
        # OLD <------------------------> NEW
        # production <---> latest <---> beta
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
      nvidia-container-toolkit.enable = true;
    };
  };
}
