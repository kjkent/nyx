{config, lib, pkgs, ...}:
{
  options = {
    hardware.i915.enable = with lib;
      mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable Intel i915 iGPU configuration";
      };
  };
  config = lib.mkIf config.hardware.i915.enable {
    boot = {
      initrd.kernelModules = ["i915"];
      kernelParams = [
        "i915.enable_guc=2"
        "i915.enable_fbc=1"
        "i915.enable_psr=0"
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
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (can be better for firefox)
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [intel-media-driver];
    };
  };
}
