{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; rev = "e8a2f6d5513fe7b7d15701b2d05404ffdc3b6dda"; }}/lenovo/thinkpad/t480s"
    (modulesPath + "/installer/scan/not-detected.nix") 
  ];

  config = {
    nixpkgs.hostPlatform = "x86_64-linux";
    hardware = {
      keyboard.layout = "gb";
      trackpoint = {
        enable = lib.mkDefault true;
        emulateWheel = lib.mkDefault config.hardware.trackpoint.enable;
      };
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-compute-runtime
          vulkan-tools
          intel-media-driver
          libva-utils
          intel-ocl
        ];
      };
      intelgpu.vaapiDriver = "intel-media-driver";
      cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
    };
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/819faa42-cc3d-42a4-8b1c-20af79285792";
        fsType = "xfs";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/1054-2CCE";
        fsType = "vfat";
        options = [
          "rw"
          "relatime"
          "fmask=0022"
          "dmask=0022"
          "codepage=437"
          "iocharset=iso8859-1"
          "shortname=mixed"
          "utf8"
          "errors=remount-ro"
        ];
      };
    };
    boot = {
      kernelParams = [
        "i915.enable_guc=2"
        "i915.enable_fbc=1"
        "i915.enable_psr=2"
      ];
      initrd.luks.devices.root.device = "/dev/disk/by-uuid/9d8357bc-68e5-4734-bad2-26476777d41e";
      kernelModules = lib.mkIf (config.services.tlp.enable) [ "acpi_call" ];
      extraModulePackages = lib.mkIf (config.services.tlp.enable) [ config.boot.kernelPackages.acpi_call ];
    };

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    # networking.useDHCP = lib.mkDefault true;
    networking.useDHCP = lib.mkDefault true;
  };
}
