{config, pkgs, ...}:
{
  config = {
    boot = {
      initrd.kernelModules = ["i915"];
      kernelParams = [
        "i915.enable_guc=2"
        "i915.enable_fbc=1"
        "i915.enable_psr=0"
        "i915.modeset=1"
      ];
    };
    environment = {
      sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
      };
      systemPackages = with pkgs; [
        intel-gpu-tools
      ];
    };
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-compute-runtime # for OpenCL
        intel-media-driver # for VA-API
        intel-media-sdk # for QSV
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [intel-media-driver];
    };
  };
}
