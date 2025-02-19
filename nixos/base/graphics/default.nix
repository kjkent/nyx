{pkgs, ...}: {
  imports = [
    ./i915.nix
    ./nvidia.nix
  ];
  config = {
    environment.systemPackages = with pkgs; [
      clinfo
      ddcui
      ddcutil
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
    #nixpkgs.overlays = [(_: pre: {
    #  # Use VCS main branch for ddcutil/ddcui as no release for 1yr+
    #  ddcutil = pre.ddcutil.overrideAttrs (_: {
    #    src = pre.fetchFromGitHub {
    #      owner = "rockowitz";
    #      repo = "ddcutil";
    #      rev = "2.2.0-dev";
    #      hash = "sha256-TJWxNeVa4UAY4jkeETi2wrCMtpzrwHiGKc1ABPFZImg=";
    #    };
    #  });
    #  ddcui = pre.ddcutil.overrideAttrs (_: {
    #    src = pre.fetchFromGitHub {
    #      owner = "rockowitz";
    #      repo = "ddcui";
    #      rev = "0.5.5-dev";
    #      hash = "sha256-8QW9XO08OJwRXNIoktPp3Z2IdaVZ3zq/s1wJPbIHW8Y=";
    #    };
    #  });
    #})];
  };
}
