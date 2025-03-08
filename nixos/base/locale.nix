{
  config,
  lib,
  ...
}: {
  options = {
    hardware.keyboard.layout = lib.mkOption {type = lib.types.str;};
  };

  config = {
    i18n.defaultLocale = "en_GB.UTF-8";
    console.keyMap = with config.hardware.keyboard;
      if layout == "gb"
      then "uk"
      else layout;
    time.timeZone = "Europe/London";
  };
}
