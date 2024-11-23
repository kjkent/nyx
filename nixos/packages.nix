{ pkgs, ... }:
{
  config = {
    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1w" # Needed by sublime4, apparently a non-issue as fix backported.
    ];
    environment = {
      systemPackages = with pkgs; [
        #### GUI: Office, Notes, Messaging
        beeper
        #cura # broken
        discord
        gimp
        #libreoffice
        obsidian
        telegram-desktop
        protonmail-desktop
        sublime4
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
        bat
        pkg-config
        hyprpicker
        brightnessctl
        virt-viewer
        swappy
        appimage-run
        yad
        inxi
        nh
        libvirt
        swww
        grim
        slurp
        swaynotificationcenter
      ];
      pathsToLink = [
        "/share/zsh" # For zsh completion
      ];
    };
    programs = {
      adb.enable = true;
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
      path = [ pkgs.flatpak ];
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
