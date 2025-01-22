{pkgs, ...}:
with pkgs; {
  config = {
    boot = {
      initrd.kernelModules = ["i915"];
      kernelParams = [
        "i915.enable_guc=2"
        "i915.enable_fbc=0"
        "i915.enable_psr=0"
        "i915.fastboot=1"
      ];
    };
    environment = {
      sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
      };
    };
    hardware.graphics = {
      enable = true;
      extraPackages = [
        intel-compute-runtime
        intel-gmmlib
        intel-gpu-tools
        intel-media-driver
        intel-media-sdk
        intel-ocl
        libva
        libvdpau-va-gl
        libvpl
        vpl-gpu-rt
      ];
      extraPackages32 = with pkgsi686Linux; [intel-media-driver];
    };
  };
}
