{ config, pkgs, user, stateVersion, email, gitId, ... }:
let
  configDir = ./home;
in
{
  imports = [ configDir ];

  config = {
    # Home Manager Settings
    home = {
      inherit stateVersion;
      homeDirectory = "/home/${user}";

      # Place Files Inside Home Directory
      file = {
        "${config.xdg.userDirs.pictures}/Wallpapers" = {
          source = "${configDir}/wallpapers";
          recursive = true;
        };
        "${config.xdg.configHome}/wlogout/icons" = {
          source = "${configDir}/wlogout";
          recursive = true;
        };
        ".face.icon".source = "${configDir}/face.jpg";
        ".config/face.jpg".source = "${configDir}/face.jpg";
        ".config/swappy/config".text = ''
          [Default]
          save_dir=${config.xdg.userDirs.pictures}/Screenshots
          save_filename_format=swappy-%Y%m%d-%H%M%S.png
          show_panel=false
          line_size=5
          text_size=20
          text_font=Ubuntu
          paint_mode=brush
          early_exit=true
          fill_shape=false
        '';
      };
    };

    # Create XDG Dirs
    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "${config.home.homeDirectory}/.local/desktop";
        documents = "${config.home.homeDirectory}/files/docs";
        download = "${config.home.homeDirectory}/downloads";
        music = "${config.home.homeDirectory}/files/audio";
        pictures = "${config.home.homeDirectory}/files/pics";
        publicShare = "${config.home.homeDirectory}/.local/shared";
        templates = "${config.home.homeDirectory}/.local/templates";
        videos = "${config.home.homeDirectory}/files/vids";
      };
      cacheHome = "${config.home.homeDirectory}/.cache";
      configHome = "${config.home.homeDirectory}/.config";
      dataHome = "${config.home.homeDirectory}/.local/share";
      stateHome = "${config.home.homeDirectory}/.local/state";
    };

    ## Virtualisation
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };

    # Styling Options
    stylix.targets = {
      waybar.enable = false;
      rofi.enable = false;
      hyprland.enable = false;
    };

    gtk = {
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    qt = {
      enable = true;
      style.name = "adwaita-dark";
      platformTheme.name = "gtk3";
    };

    programs = {
      home-manager.enable = true;
      bash.enable = true; # Must be enabled to set session vars
      foot.enable = true;

      git = {
        enable = true;
        userName = gitId; 
        userEmail = email;
      };
      # Provides command-not-found
      nix-index = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}
