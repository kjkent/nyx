{ pkgs, ... }: with pkgs;
{
  config = {
    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1w" # Needed by sublime4, apparently a non-issue as fix backported.
    ];
    environment = {
      systemPackages = [
        #### GUI: Office, Notes, Messaging
        beeper
        discord
        gimp
        hyprpicker
        libreoffice
        obsidian
        protonmail-desktop
        sublime4
        super-productivity
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
        btop
        dconf-editor
        dmidecode
        killall
        lsof
        lm_sensors
        pciutils
        pcsc-tools
        pstree
        usbutils
        inxi
        lshw
        util-linux

        libnotify
        ydotool
        wl-clipboard
        socat
        cowsay
        brightnessctl
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
        #package = (appimage-run.override {
        #  extraPkgs = p: with p; [ ]; # If appimages need extra packages, put here
        #});
      };
      nix-ld = {
        enable = true;
        # libraries = [ ]; # Put extra library packages here if needed
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
