{ lib, pkgs, stdenv, ... }:
with pkgs;
let
  pname = "orca-slicer";
  version = "2.2.0";

  meta = with lib; {
    description = "Orca Slicer is an open source slicer for FDM printers.";
    homepage = "https://github.com/SoftFever/OrcaSlicer";
    changelog = "https://github.com/SoftFever/OrcaSlicer/releases/tag/v${version}";
    license = licenses.agpl3Only;
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
in stdenv.mkDerivation {
  inherit meta pname src version;

  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out"
    cp -a "${appimageContents}"/* "$out/"
    
    install \
      -D \
      --mode 444 \
      --target-directory "$out/share/applications" \
      "${desktopItem}/share/applications/${pname}.desktop"

    install \
      -D \
      --mode 444 \
      --target-directory "$out/share/icons/hicolor/192x192/apps/" \
      "$out/OrcaSlicer.png" 

    rm "$out/OrcaSlicer.desktop"
  '';

  postFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${
        lib.makeLibraryPath [
          cairo
          dbus.lib
          expat
          fontconfig.lib
          gdk-pixbuf
          glib
          glibc
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gtk3
          kdePackages.wayland.out
          libdrm
          libgcc.lib
          libGL
          libGLX
          libudev0-shim
          libva
          libxcrypt
          libz
          mesa
          pango
          (webkitgtk_4_0.overrideAttrs (old: {
            buildInputs = [ mesa ] ++ old.buildInputs;
          }))
          udev
          vulkan-loader
          xorg.libX11
          zlib
        ]
      }" \
      "$out/bin/${pname}"
  '';
}
