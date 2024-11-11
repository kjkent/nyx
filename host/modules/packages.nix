{ pkgs, ... }:
{
  config = {
    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1w" # Needed by sublime4
    ];
    environment.systemPackages = with pkgs; [
      #### GUI: Office, Notes, Messaging,
      beeper
      #cura # broken
      discord
      file-roller
      gimp
      google-chrome
      libreoffice-fresh
      obsidian
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
      chafa
      glow
      less
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
      iw # Low-level wifi adapter cli tool
      ethtool # Low-level ethernet cli tool
      wireguard-tools
      util-linux
      btop
      tlp # Power management
      inetutils
      pam_u2f
      pciutils
      tpm2-tss
      tpm2-tools
      usbutils
      pcsc-tools
      lsof
      pstree

      # Compression & filesystem
      gnutar
      gzip
      unzip
      unrar
      xfsprogs
      xz
      
      noto-fonts-emoji-blob-bin
      
      rsync
      wget
      killall
      eza
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
      ffmpeg
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
      playerctl
      nh
      nixfmt-rfc-style
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

    programs.nix-ld.enable = true;

    programs.direnv = {
      enable = true;
      silent = false;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
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
