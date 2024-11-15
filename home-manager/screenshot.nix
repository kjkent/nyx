{
  config,
  pkgs,
  ...
}:
{
  config = {
    home = {
      file."${config.xdg.configHome}/swappy/config".text = ''
        [Default]
        save_dir=${config.xdg.userDirs.pictures}/screenshots
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
          grim -g "$(slurp)" - | swappy -f -
        '')
      ];
    };
  };
}
