{ pkgs, ... }: with pkgs; let
  stdPkgs = [
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
  ] ++ (appimageTools.multiPkgs pkgs);
in {
  config = {
    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1w" # Needed by sublime4, apparently a non-issue as fix backported.
    ];
    environment = {
      systemPackages = [
        #### GUI: Office, Notes, Messaging
        beeper
        cura
        discord
        gimp
        grim
        hyprpicker
        libreoffice
        obsidian
        pkgs.orca-slicer
        protonmail-desktop
        slurp
        sublime4
        super-productivity
        swappy
        swaynotificationcenter
        teams-for-linux
        telegram-desktop
        ####

        ###### User CLI
        scrcpy # Android
        tmux
        tio
        chafa # Convert images to ASCII art
        glow # Render markdown in terminal
        less
        jq
        xdg-ninja # Suggests home cleaning tips

        ##### Dev tools
        android-studio
        dfu-util
        docker-compose
        biome
        bruno
        jetbrains.pycharm-community-bin
        jetbrains.webstorm
        git
        meson
        ninja
        nixd
        neovide
        shellcheck
        tinyxxd # xxd (usually bundled with vim)
        uv
        (vscode.override { commandLineArgs = [ "--password-store=gnome-libsecret" ]; })

        ###### System management & monitoring CLI utils
        appimagekit
        appimage-run
        btop
        dconf-editor
        dmidecode
        killall
        lsof
        lm_sensors
        pciutils
        pcsc-tools
        pstree
        tlp # Power management
        usbutils
        util-linux

        cmatrix
        libnotify
        ydotool
        duf
        ncdu
        wl-clipboard
        socat
        cowsay
        ripgrep
        lshw
        pkg-config
        brightnessctl
        virt-viewer
        libvirt
        yad
        inxi
        nh
      ];
      pathsToLink = [
        "/share/zsh" # For zsh completion
      ];
    };
    programs = {
      adb.enable = true;
      appimage = {
        enable = true;
        binfmt = true; # Automatically run with `appimage-run` interpreter
        package = (appimage-run.override {
          extraPkgs = p: with p; [
            ffmpeg
            imagemagick
            vulkan-headers
          ] ++ stdPkgs;
        });
      };
      nix-ld = {
        enable = true;
        libraries = stdPkgs; 
      };
      dconf.enable = true;
      direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
      };
    };

    services = {
      flatpak.enable = true;
    };

    systemd.services.flatpak-repo = {
      path = [ flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        '';
    };
  };
}
