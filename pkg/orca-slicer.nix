# Adapted from: https://github.com/afresquet/dotfiles/blob/de11f33c5fae9bcdae9bdb8b5e55e4c33e4f6dba/pkgs/cura.nix
{ lib, pkgs, ... }:
with pkgs;
let
  pname = "orca-slicer";
  version = "2.2.0";

  meta = with lib; {
    description = "Orca Slicer is an open source slicer for FDM printers.";
    homepage = "https://github.com/SoftFever/OrcaSlicer";
    changelog = "https://github.com/SoftFever/OrcaSlicer/releases/tag/v${version}";
    license = licenses.agpl3;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    mainProgram = pname;
  };

  src = fetchurl {
    url = "https://github.com/SoftFever/OrcaSlicer/releases/download/v${version}/OrcaSlicer_Linux_V${version}.AppImage";
    hash = "sha256-3uqA3PXTrrOE0l8ziRAtmQ07gBFB+1Zx3S6JhmOPrZ8=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "${pname} %U";
    icon = "OrcaSlicer";
    terminal = false;
    desktopName = "Orca Slicer";
    comment = meta.description;
    categories = [ "3DGraphics" "Engineering" "Utility" ];
    mimeTypes = [
      "model/stl"
      "application/vnd.ms-3mfdocument"
      "application/prs.wavefront-obj"
      "application/x-amf"
    ];
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraPkgs =
    p: with p; [
      libGL
      libGLX
      vulkan-loader
      vulkan-headers
      webkitgtk_4_0
      zlib-ng
    ];

  extraInstallCommands = ''
    # This will be plan B if the extraPkg doesn't work 
    #"${patchelf}"/bin/patchelf --set-rpath "${webkitgtk_4_0}"/lib "$out"/bin/"${pname}"

    # This will be plan C if patchelf doesn't work
    #ln -s "${webkitgtk_4_0}/lib/libwebkit2gtk-4.0.so.37" \
    #  "$out"/usr/lib/x86_64-linux-gnu/libwebkit2gtk-4.0.so.37

    install \
      -D \
      --mode 644 \
      --target-directory "$out"/share/icons/hicolor/128x128/apps \
      "${appimageContents}"/resources/images/OrcaSlicer_128px.png

    install \
      -D \
      --mode 644 \
      --target-directory "$out"/share/applications \
      "${desktopItem}"/share/applications/"${pname}".desktop
  '';
}
