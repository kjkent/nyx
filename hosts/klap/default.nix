{lib, nixosUser, ...}: {
  config = {
    boot.isBios = true;
    system.stateVersion = "24.11";
    hardware = {
      i915.enable = true;
      keyboard.layout = "gb";
      laptop = {
        powerManagement.enable = true;
        thinkpad.enable = true;
      };
    };
  };
}
