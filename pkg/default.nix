{ pkgs, ... }:
{
  config = {
    nixpkgs.overlays = with pkgs; [
      (_: pre: {
        mkFontPkg = callPackage ./mkFontPkg.nix pre.stdenv;
        cura = callPackage ./cura.nix pre;
      })
    ];
  };
}
