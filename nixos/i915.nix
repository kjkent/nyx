{pkgs, ...}:
with pkgs; {
  config = {
    boot = {
      initrd.kernelModules = ["i915"];
      kernelParams = [
        "i915.enable_guc=3"
        "i915.enable_fbc=1"
        # PSR:
        # 0 == ...
        # 2 == awful flickering
        # 3 == less awful flickering
        "i915.enable_psr=0"
      ];
    };
    environment = {
      sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
      };
      systemPackages = [
        libva-utils
      ];
    };
    hardware.graphics = {
      enable = true;
      extraPackages = [
        intel-compute-runtime
        intel-media-driver
        intel-ocl
        vpl-gpu-rt
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgsi686Linux; [intel-media-driver];
    };
  };
}
