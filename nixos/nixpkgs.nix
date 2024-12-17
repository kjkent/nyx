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
    # In effect during runtime
    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
    nixpkgs = {
      overlays = with inputs; [
        # Makes nixpkgs revisions/branches available as string val
        (initPkgs "master" nixpkgs-master)
        (initPkgs "stable" nixpkgs-stable)
        (initPkgs "unstable" nixpkgs-unstable)

        # pkgs.{{vscode-marketplace,open-vsx}{,-release},forVSCodeVersion "<ver>"}
        # overlay checks for compatibility anyway (I think)
        inputs.vscode-exts.overlays.default
      ];
      config.allowUnfree = true; # Only for build
      hostPlatform = lib.mkDefault "x86_64-linux";
    };
  };
}
