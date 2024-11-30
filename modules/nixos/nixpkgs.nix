{
  config,
  inputs,
  lib,
  ...
}:
let
  initPkgs = namespace: pkgs: (post: pre: with config.nixpkgs; {
    ${namespace} = import pkgs {
      inherit (pre.stdenv.hostPlatform) system;
      inherit (config) allowUnfree;
    };
  });
in
{
  config = {
    nixpkgs = {
      overlays = with inputs; [
        # Makes old stable nixpkgs available as pkgs.pkgs-[relYY_relMM]
        (initPkgs "pkgs-24_11" nixpkgs-24_11)
        (initPkgs "pkgs-24_05" nixpkgs-24_05)
      ];
      config.allowUnfree = true; # Only for build
      hostPlatform = lib.mkDefault "x86_64-linux";
    };
    # In effect during runtime
    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  };
}
