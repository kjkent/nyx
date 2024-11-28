{ pkgs, ... }: {
  config = {
    nixpkgs.overlays = with pkgs; [
      (_: pre: let
        callPkg = pkg: callPackage pkg pre;
      in {
        mkFontPkg = callPkg ./mkFontPkg.nix;
        cura = callPkg ./cura.nix;
        orca-slicer = callPkg ./orca-slicer;
      })
    ];
  };
}
