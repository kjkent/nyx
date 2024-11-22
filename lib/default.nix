{pkgs, ...}: {
  config = {
    nixpkgs.overlays = with pkgs; [
      (post: pre: {
        mkFontPkg = (callPackage ./mkFontPkg.nix pre.stdenv);
      })
    ];
  };
}
