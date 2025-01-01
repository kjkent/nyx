# Adapted from: https://github.com/afresquet/dotfiles/blob/de11f33c5fae9bcdae9bdb8b5e55e4c33e4f6dba/pkgs/cura.nix
{pkgs, ...}:
with pkgs; let
  pname = "cura";
  version = "5.9.0";

  meta = with lib; {
    description = "Cura converts 3D models into paths for a 3D printer. It prepares your print for maximum accuracy, minimum printing time and good reliability with many extra features that make your print come out great.";
    homepage = "https://ultimaker.com/software/ultimaker-cura/";
    changelog = "https://github.com/Ultimaker/Cura/releases/tag/${version}";
    license = licenses.lgpl3Plus;
    platforms = ["x86_64-linux"];
    sourceProvenance = [sourceTypes.binaryNativeCode];
    mainProgram = pname;
  };

  src = fetchurl {
    url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-X64.AppImage";
    hash = "sha256-STtVeM4Zs+PVSRO3cI0LxnjRDhOxSlttZF+2RIXnAp4=";
  };

  appimageContents = appimageTools.extract {inherit pname version src;};

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = "cura-icon";
    terminal = false;
    desktopName = "Ultimaker Cura";
    comment = meta.description;
    categories = ["Utility"];
    mimeTypes = [
      "model/3mf"
      "application/vnd.ms-3mfdocument"
      "application/prs.wavefront-obj"
      "application/vnd.ms-package.3dmanufacturing-3dmodel+xml"

      "application/x-amf"
      "application/x-ctm"
      "text/x-gcode"
      "model/obj"
      "application/x-ply"

      "model/gltf-binary"
      "model/gltf+json"

      "model/stl"
      "model/x.stl-ascii"
      "model/x.stl-binary"

      "model/vnd.collada+xml"
      "model/vnd.collada+xml+zip"

      "model/x3d"
      "model/x3d+binary"
      "model/x3d+fastinfoset"
      "model/x3d+vrml"
      "model/x3d+xml"
    ];
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs = p:
      with p; [
        vulkan-loader
        vulkan-headers
        libGL
        libGLX
        zlib-ng
      ];

    extraInstallCommands = ''
      install \
        -D \
        --mode 444 \
        --target-directory "$out"/share/icons/hicolor/128x128/apps \
        "${appimageContents}"/share/cura/resources/images/cura-icon.png

      install \
        -D \
        --mode 444 \
        --target-directory "$out"/share/applications \
        "${desktopItem}"/share/applications/*.desktop
    '';
  }
