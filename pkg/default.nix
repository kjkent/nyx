{pkgs, ...}: {
  config = {
    nixpkgs.overlays = with pkgs; [
      (
        _: pre: let
          callPkg = pkg: callPackage pkg pre;
        in {
          bibata-modern-rainbow = callPkg ./bibata-modern-rainbow.nix;
          cura = callPkg ./cura.nix;
          httptoolkit-appimage = callPkg ./httptoolkit-appimage.nix;
          mkFontPkg = callPkg ./mkFontPkg.nix;
          stm32cubeprog = callPkg ./stm32cubeprog.nix;
        }
      )
    ];
  };
}
