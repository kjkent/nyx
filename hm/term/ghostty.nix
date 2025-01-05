{pkgs, ...}: let
  ghostty = pkgs.unstable.ghostty;
in {
  config = {
    home.packages = [ ghostty ];
    programs = {
      bat.syntaxes.ghostty = {
        src = ghostty;
        file = "share/bat/syntaxes/ghostty.sublime-syntax";
      };
      zsh.initExtra = ''
        if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
          source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
        fi
      '';
    };
  };
}
