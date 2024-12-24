{nixosModulesPath, ...}: {
  imports = [
    "${nixosModulesPath}/i915.nix"
    "${nixosModulesPath}/thinkpad.nix"
    "${nixosModulesPath}/laptop_power.nix"
  ];
  config = {
    system.stateVersion = "24.11";
    hardware.keyboard.layout = "gb";
  };
}
