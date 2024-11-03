{ config, lib, ... }:
{
  options = {
    hardware.keyboard.layout = lib.mkOption { type = lib.types.str; };
  };

  config = {
    console.keyMap = with config.hardware.keyboard;
      if layout == "gb" then "uk" else layout;
  };
}
