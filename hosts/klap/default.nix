_: {
  config = {
    boot.isBios = true;
    encryptedRootFs = false;
    system.stateVersion = "24.11";
    hardware = {
      i915.enable = true;
      keyboard.layout = "gb";
      laptop = {
        powerManagement.enable = true;
        thinkpad.enable = true;
      };
    };
    networking.wg-quick.networks.home.enable = true;
  };
}
