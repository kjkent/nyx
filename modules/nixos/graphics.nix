{ pkgs, ... }:
{
  config = {
    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          libGL
          libGLX
          libva-utils
          ocl-icd
          vulkan-tools
          vulkan-loader
          vulkan-headers
        ];
      };
    };
  };
}
