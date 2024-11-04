{ pkgs, ... }:
{
  config = {
    programs = {
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-volman # Removable storage management
        ];
      };
      xfconf.enable = true; # Prefs backend
    };
    services = {
      gvfs.enable = true; # Mount, trash, sshfs support
      tumbler.enable = true; # Image thumbnail support
    };
    environment.systemPackages = with pkgs; [
      sshfs  # SFTP functionality for GVFS
      webp-pixbuf-loader # webp thumbnails
      poppler_gi # pdf thumbnails
      ffmpegthumbnailer  # video thumbnails
      f3d  # 3D file thumbnails (stl, obj)
    ];
  };
}