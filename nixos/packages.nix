{pkgs, ...}:
with pkgs; {
  config = {
    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1w" # Needed by sublime4, apparently a non-issue as fix backported.
    ];
    environment = {
      systemPackages = [
        #### GUI: Office, Notes, Messaging
        beeper
        blender
        brave
        discord
        gimp
        libreoffice
        obsidian
        protonmail-desktop
        sublime4
        super-productivity
        teams-for-linux
        #telegram-desktop
        ####

        ###### User CLI
        chafa # Convert images to ASCII art
        glow # Render markdown in terminal
        jq
        less
        scrcpy # Android
        tio
        tmux
        xdg-ninja # Suggests home cleaning tips

        ###### System management & monitoring CLI utils
        brightnessctl
        btop
        dconf-editor
        dmidecode
        killall
        lsof
        lm_sensors
        pciutils
        pcsc-tools
        pstree
        socat
        ssh-to-pgp
        usbutils
        inxi
        lshw
        util-linux
        wl-clipboard
        ydotool
      ];
      pathsToLink = [
        "/share/zsh" # For zsh completion
      ];
    };
    programs = {
      appimage = {
        enable = true;
        binfmt = true; # Automatically run with `appimage-run` interpreter
        #package = (appimage-run.override {
        #  extraPkgs = p: with p; [ ]; # If appimages need extra packages, put here
        #});
      };
      dconf.enable = true;
    };

    services = {
      flatpak.enable = true;
    };

    systemd.services.flatpak-repo = {
      path = [flatpak];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
