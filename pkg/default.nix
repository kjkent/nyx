{pkgs, ...}: {
  config = {
    nixpkgs.overlays = with pkgs; [
      (
        _: pre: let
          callPkg = pkg: callPackage pkg pre;
        in {
          cura = callPkg ./cura.nix;
          mkFontPkg = callPkg ./mkFontPkg.nix;
        }
      )
    ];
  };
}
