# mkFontPkg - create font package for NixOS 
#
# Usage:
# ```
# fonts.packages = [
#   (pkg.mkFontPkg "Comic Sans" {
#     secret = true;
#     source = "${self}/sops/comic-sans.tar.gz.enc"
#   })
# ];
# ```

{ lib, stdenv, sops, ... }: fontName: fontSpec: 
  stdenv.mkDerivation {
    pname = fontName;
    version = "1.0.0";
    meta.description = "Font package for ${fontName}";
    src = if fontSpec.encrypted
          then sops.decryptFile fontSpec.source
          else fontSpec.source;

    installPhase = ''
      install_dir = "$out/share/fonts/${fontName}"
      install -D --mode 644 --target-directory "$install_dir" "$src"
    '';
}
