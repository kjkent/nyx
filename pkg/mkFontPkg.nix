# mkFontPkg - create font package for NixOS
#
# Usage:
# ```
# fonts.packages = [
#   (pkg.mkFontPkg "Comic Sans" {
#     source = "${self}/fonts/comic-sans.tar.gz"
#   })
# ];
# ```
# TODO: Make this accept remote (eg GitHub via fetchFromGitHub/fetchZip) source
{stdenv, ...}: fontName: fontSpec:
stdenv.mkDerivation {
  pname = fontName;
  version = "1.0.0";
  meta.description = "Font package for ${fontName}";
  src = fontSpec.source;

  installPhase = ''
    install_dir="$out/share/fonts/${fontName}"
    install -D --mode 444 --target-directory "$install_dir" *
  '';
}
