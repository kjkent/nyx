{nixosModulesPath, nixosUser, ...}: {
  imports = [
    "${nixosModulesPath}/i915.nix"
    "${nixosModulesPath}/thinkpad.nix"
    "${nixosModulesPath}/laptop_power.nix"
  ];
  config = {
    boot.isBios = true;
    system.stateVersion = "24.11";
    hardware.keyboard.layout = "gb";
    home-manager.users.${nixosUser.username}.programs.firefox.policies.Preferences."media.av1.enabled" = {Locked = true; Value = false;};
  };
}
