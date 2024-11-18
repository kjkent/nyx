{pkgs, ...}: {
  config = {
    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1w" # Needed by sublime4, apparently a non-issue as fix backported.
    ];
    environment = {
      systemPackages = with pkgs; [
        #### GUI: Office, Notes, Messaging,
        beeper
        #cura # broken
        discord
        file-roller
        gimp
        libreoffice-fresh
        obsidian
        telegram-desktop
        protonmail-desktop
        protonvpn-gui
        spotify
        sublime4
        ####

        ###### User CLI
        scrcpy # Android
        android-tools # fastboot, adb
        diff-so-fancy
        docker-compose
        docker
        tmux
        tio
        chafa # Convert images to ASCII art
        glow # Render markdown in terminal
        less
        jq
        dfu-util
        xdg-ninja # Suggests home cleaning tips
        # yubikey-manager broken

        ##### Dev tools
        biome
        git
        meson
        ninja
        nixd
        neovide
        shellcheck
        tinyxxd # xxd (usually bundled with vim)
        (vscode.override {
          commandLineArgs = ["--password-store=gnome-libsecret"];
        })

        ###### System management & monitoring CLI utils
        btop
        dconf-editor
        ethtool # Low-level ethernet cli tool
        inetutils
        iw # Low-level wifi adapter cli tool
        killall
        lsof
        lm_sensors
        pam_u2f
        pciutils
        pcsc-tools
        pstree
        tlp # Power management
        tpm2-tss
        tpm2-tools
        usbutils
        util-linux
        wireguard-tools

        # Compression & filesystem
        gnutar
        gzip
        unzip
        unrar
        xfsprogs
        xz

        # File utils
        rsync
        wget
        eza
        cmatrix
        libnotify
        v4l-utils
        ydotool
        duf
        ncdu
        wl-clipboard
        socat
        cowsay
        ripgrep
        lshw
        bat
        pkg-config
        hyprpicker
        brightnessctl
        virt-viewer
        swappy
        appimage-run
        networkmanagerapplet
        yad
        inxi
        ffmpeg
        playerctl
        nh
        libvirt
        swww
        grim
        slurp
        swaynotificationcenter
        imv
        mpv
        pavucontrol
        tree
        greetd.tuigreet
      ];
      pathsToLink = [
        "/share/zsh" # For zsh completion
      ];
    };
    programs = {
      nix-ld.enable = true;
      dconf.enable = true;
      direnv = {
        enable = true;
        silent = false;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
    };

    services = {
      flatpak.enable = true;
    };

    systemd.services.flatpak-repo = {
      path = [pkgs.flatpak];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    boot.binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
}
