{
  config,
  pkgs,
  ...
}: {
  config = {
    home = {
      # 'Screenshots' allows compat with Android (FAT32 fs is case insensitive)
      file."${config.xdg.configHome}/swappy/config".text = ''
        [Default]
        save_dir=${config.xdg.userDirs.pictures}/Screenshots
        save_filename_format=screen-%Y%m%d-%H%M%S.png
        show_panel=false
        line_size=5
        text_size=20
        text_font=Ubuntu
        paint_mode=brush
        early_exit=true
        fill_shape=false
      '';
      packages = with pkgs; [
        grim
        slurp
        swappy
        (writeShellScriptBin "screenshot" ''
          grim -c -g "$(slurp)" - | swappy -f -
        '')
      ];
    };
  };
}
