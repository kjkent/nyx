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
      sublime4
      #### 
      android-tools # fastboot, adb
      iw # Low-level wifi adapter cli tool
      ethtool # Low-level ethernet cli tool
      docker-compose
      docker
      wireguard-tools
      util-linux
      tmux
      tio
      
      less
      inetutils
      tinyxxd # xxd (usually bundled with vim)
      gnutar
      gzip
      diff-so-fancy
      dfu-util
      
      chafa
      btop
      libreoffice-fresh
      noto-fonts-emoji-blob-bin
      
      pam_u2f
      pcsc-tools
      rsync
      shellcheck
      tlp # Power management
      tpm2-tss
      tpm2-tools
      usbutils
      xdg-ninja # Suggests home cleaning tips
      xz
      # yubikey-manager broken
      xfsprogs
      scrcpy # Android
      protonvpn-gui
      chezmoi
      nixd
      biome
      (vscode.override {
        commandLineArgs = ["--password-store=gnome-libsecret"];
      })
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
      unzip
      unrar
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
