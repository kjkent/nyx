_: {
  config = {
    hardware.trackpoint = {
      enable = true;
      emulateWheel = true;
    };
    services = {
      throttled.enable = true;
      tp-auto-kbbl = {
        enable = true;
        device = "/dev/input/event1"; # `evtest` lists event devices
        arguments = [
          "--brightness"
          "2"
          "--timeout"
          "60"
        ];
      };
    };
  };
}
