{ pkgs, ... }:
{
  config = {
    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1w" # Needed by sublime4
    ];
    environment.systemPackages = with pkgs; [
      #### GUI: Office, Notes, Messaging,
      #cura # broken
      obsidian
      protonmail-desktop
      libreoffice-fresh
      sublime4
      beeper
      (vscode.override {
        commandLineArgs = ["--password-store=gnome-libsecret"];
      })
      ####

      ###### User CLI
      scrcpy # Android
      diff-so-fancy
      android-tools # fastboot, adb
      docker-compose
      docker
      tmux
      tio
      chafa
      shellcheck
      glow
      less
      dfu-util
      xdg-ninja # Suggests home cleaning tips
      # yubikey-manager broken
      tinyxxd # xxd (usually bundled with vim)

      ###### System management & monitoring CLI utils
      iw # Low-level wifi adapter cli tool
      ethtool # Low-level ethernet cli tool
      wireguard-tools
      util-linux
      btop
      tlp # Power management
      inetutils
      pam_u2f
      tpm2-tss
      tpm2-tools
      usbutils
      pcsc-tools

      # Compression utils
      gnutar
      gzip
      unzip
      unrar
      xz
      
      noto-fonts-emoji-blob-bin
      
      rsync
      xfsprogs
      protonvpn-gui
      chezmoi
      nixd
      biome
      google-chrome
      wget
      killall
      eza
      git
      cmatrix
      lolcat
      libvirt
      lxqt.lxqt-policykit
      lm_sensors
      libnotify
      v4l-utils
      ydotool
      duf
      ncdu
      wl-clipboard
      pciutils
      ffmpeg
      socat
      cowsay
      ripgrep
      lshw
      bat
      pkg-config
      meson
      hyprpicker
      ninja
      brightnessctl
      virt-viewer
      swappy
      appimage-run
      networkmanagerapplet
      yad
      inxi
      playerctl
      nh
      nixfmt-rfc-style
      discord
      libvirt
      swww
      grim
      slurp
      file-roller
      swaynotificationcenter
      imv
      mpv
      gimp
      pavucontrol
      tree
      spotify
      neovide
      greetd.tuigreet
    ];

    programs.direnv = {
      enable = true;
      silent = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    services.flatpak.enable = true;
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
