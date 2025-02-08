{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      clinfo
      gpu-viewer
      libva-utils
      mesa-demos # for glxgears, eglinfo, glxinfo
      vulkan-tools
    ];
    hardware = {
      graphics = {
        enable = true;
      };
    };
  };
}
