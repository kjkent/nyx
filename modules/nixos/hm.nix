{
  hmModulesPath,
  inputs,
  specialArgs, # Nix automatically adds specialArgs as an attrSet within itself!
  nixosUser, # (so it can be passed here without overrriding HM's `config`)
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  config = {
    home-manager = {
      users.${nixosUser.username} = import hmModulesPath;
      extraSpecialArgs = specialArgs;
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
    };
  };
}
