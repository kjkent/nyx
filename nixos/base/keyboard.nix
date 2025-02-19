{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    hardware.keyboard.layout = lib.mkOption {type = lib.types.str;};
  };

  config = {
    environment.systemPackages = with pkgs; [
      qmk
    ];
    console.keyMap = with config.hardware.keyboard;
      if layout == "gb"
      then "uk"
      else layout;
  };
}
