{ ... }:
{
  imports = [
    ../modules/nvidia.nix
  ];

  config = {
    boot.initrd.luks.devices.root.device = "/dev/disk/by-uuid/7459a9fb-1ee9-46b9-b1e5-0bd15ab39e9f";
    fileSystems = {
      "/".device = "/dev/disk/by-uuid/0e4f52d1-068a-4122-9199-ad56aaafab8b";
      "/boot".device = "/dev/disk/by-uuid/EC43-52F8";
    };
    hardware.keyboard.layout = "us";
    programs.hyprland.monitor = [
      "monitor = HDMI-A-1, 2560x1080, 0x0, 1"
      "monitor = DP-1, 1920x1080, -1080x0, 1, transform, 3"
    ];
  };
}



