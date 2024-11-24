# Credit: https://github.com/afresquet/dotfiles/blob/de11f33c5fae9bcdae9bdb8b5e55e4c33e4f6dba/pkgs/cura.nix
{lib, fetchurl, makeDesktopItem, appimageTools, ...}:
appimageTools.wrapType2 rec {
  pname = "cura";
  version = "5.9.0";

  src = fetchurl {
    url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-X64.AppImage";
    hash = "sha256-STtVeM4Zs+PVSRO3cI0LxnjRDhOxSlttZF+2RIXnAp4=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "cura";
      exec = "cura";
      terminal = false;
      desktopName = "Ultimaker Cura";
      comment = meta.description;
      categories = [ "Utility" ];
    })
  ];

  meta = with lib; {
    description = "3D printer/slicing GUI built on top of the Uranium framework";
    homepage = "https://ultimaker.com/software/ultimaker-cura/";
    changelog = "https://github.com/Ultimaker/Cura/releases/tag/${version}";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    mainProgram = "cura";
  };
}