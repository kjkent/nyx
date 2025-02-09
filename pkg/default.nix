{pkgs, ...}: {
  config = {
    nixpkgs.overlays = with pkgs; [
      (
        _: pre: let
          callPkg = pkg: callPackage pkg pre;
        in {
          bibata-modern-rainbow = callPkg ./bibata-modern-rainbow.nix;
          cura = callPkg ./cura.nix;
          mkFontPkg = callPkg ./mkFontPkg.nix;
        }
      )
    ];
  };
}
