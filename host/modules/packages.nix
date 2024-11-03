{ pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      chezmoi
      nixd
      biome
      (vscode.override {
        commandLineArgs = ["--password-store=gnome-libsecret"];
      })
      google-chrome
      vim
      wget
      killall
      eza
      git
      cmatrix
      lolcat
      htop
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

    services.guix.enable = false;

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
