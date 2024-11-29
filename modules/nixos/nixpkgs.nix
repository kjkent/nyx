{
  config,
  inputs,
  lib,
  ...
}:
let
  initPkgs = namespace: pkgs: (
    _: _: with config.nixpkgs; {
      ${namespace} = import pkgs {
        system = 
          hostPlatform.content.system # if wrapped in lib.mkDefault and is attrset
          or hostPlatform.content # if a default and a string
          or hostPlatform.system # if not a default and is an attrset
          or hostPlatform # not a default, just a string
          ;
        inherit (config) allowUnfree;
      };
    }
  );
in
{
  config = {
    nixpkgs = {
      overlays = with inputs; [
        # Makes stable nixpkgs available as pkgs.stable
        (initPkgs "stable" nixpkgs-stable)

        # Makes orca PR available as pkgs.orca
        (initPkgs "orca" nixpkgs-orca)
      ];
      config.allowUnfree = true; # Only for build
      hostPlatform = lib.mkDefault "x86_64-linux";
    };
    # In effect during runtime
    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  };
}
