{ pkgs, ... }: with pkgs;
{
  config = {
    boot = {
      initrd.kernelModules = [ "i915" ];
      kernelParams = [
        "i915.enable_guc=3"
        "i915.enable_fbc=1"
        "i915.enable_psr=3"
      ];
    };
    environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
    hardware.graphics = {
      enable = true;
      extraPackages = [
        intel-compute-runtime
        vulkan-tools
        intel-media-driver
        libva-utils
        intel-ocl
        vpl-gpu-rt
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgsi686Linux; [ intel-media-driver ];
    };
  };
}
