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
        # Makes stable nixpkgs available as pkgs.stable
        (initPkgs "stable" nixpkgs-stable)
      ];
      config.allowUnfree = true; # Only for build
      hostPlatform = lib.mkDefault "x86_64-linux";
    };
    # In effect during runtime
    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  };
}
