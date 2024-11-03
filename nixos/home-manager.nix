{ home-manager, specialArgs, ... }:
let
 user = specialArgs.user;
 flakeRoot = specialArgs.flakeRoot;
in
home-manager.nixosModules.home-manager {
  home-manager = {
    users.${user} = import "${flakeRoot}"/user/${user}/home-manager.nix;
    extraSpecialArgs = specialArgs;

    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };
}
