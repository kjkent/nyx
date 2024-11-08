{ ... }:
{
  imports = [
    ../modules/i915.nix
    ../modules/thinkpad.nix
    ../modules/laptop_power.nix
  ];

  config = {
    hardware.keyboard.layout = "gb";
    fileSystems = {
      "/".device = "/dev/disk/by-uuid/819faa42-cc3d-42a4-8b1c-20af79285792";
      "/boot".device = "/dev/disk/by-uuid/1054-2CCE";
    };
    boot = {
      initrd.luks.devices.root.device = "/dev/disk/by-uuid/9d8357bc-68e5-4734-bad2-26476777d41e";
    };
  };
}
