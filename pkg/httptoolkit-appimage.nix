{pkgs, ...}:
with pkgs; let
  name = "httptoolkit";
  pname = "${name}-appimage";
  version = "1.19.4";

  src = fetchurl {
    url = "https://github.com/${name}/${name}-desktop/releases/download/v${version}/HttpToolkit-${version}.AppImage";
    hash = "sha256-UqA0okfWVkfg4I68D7tUfh6BzNGOuNPIKsRcaujeW1w=";
  };

  appimageContents = appimageTools.extract {inherit pname version src;};

  desktopItem = makeDesktopItem {
    inherit name;
    exec = name;
    icon = name;
    terminal = false;
    desktopName = "HTTP Toolkit";
    comment = "HTTP(S) debugging, development & testing tool";
    categories = ["Development"];
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = p:
      with p; [
        glib
        nss_latest
        nspr
        dbus
        atk
        cups
        libdrm
        gdk-pixbuf
        gtk3
        pango
        cairo
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        mesa
        expat
        xorg.libxcb
        libxkbcommon
        alsa-lib
        at-spi2-atk
      ];

    extraInstallCommands = ''
      ln -s "$out/bin/${pname}" "$out/bin/${name}"

      install \
        -D \
        --mode 644 \
        --target-directory "$out/share/icons/hicolor/scalable/apps" \
        "${appimageContents}/usr/share/icons/hicolor/scalable/${name}.svg"

      install \
        -D \
        --mode 644 \
        --target-directory "$out/share/applications" \
        "${desktopItem}/share/applications"/*.desktop
    '';
  }
