# mkFontPkg - create font package for NixOS 
#
# Usage:
# ```
# fonts.packages = [
#   (pkg.mkFontPkg "Comic Sans" {
#     source = "${self}/sops/comic-sans.tar.gz"
#   })
# ];
# ```
 
{ stdenv, ... }: fontName: fontSpec: 
  stdenv.mkDerivation {
    pname = fontName;
    version = "1.0.0";
    meta.description = "Font package for ${fontName}";
    src = fontSpec.source;

    installPhase = ''
      install_dir="$out/share/fonts/${fontName}"
      
      find . -iname '*.otf'   \
          -o -iname '*.ttf'   \
          -o -iname '*.woff'  \
          -o -iname '*.woff2' \
          -exec \
            install -D --mode 644 --target-directory "$install_dir" {}\;
    '';
}
