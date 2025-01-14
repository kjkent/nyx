{config, lib, pkgs, ...}: let
in {
  config = {
    programs = {
      ghostty = {
        enable = true;
        clearDefaultKeybinds = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        installVimSyntax = true;
        package = pkgs.unstable.ghostty; 
        settings = {
          keybind = [
            "ctrl+t>c=new_tab"
            "ctrl+t>p=previous_tab"
            "ctrl+t>n=next_tab"
            "ctrl+t>/=last_tab"

            "ctrl+s>s=new_split:auto"
            "ctrl+s>h=new_split:left"
            "ctrl+s>j=new_split:down"
            "ctrl+s>k=new_split:up"
            "ctrl+s>l=new_split:right"
            "ctrl+s>e=equalize_splits"

            "ctrl+h=goto_split:left"
            "ctrl+j=goto_split:bottom"
            "ctrl+k=goto_split:top"
            "ctrl+l=goto_split:right"

            "ctrl+q=close_surface"
            "ctrl+shift+q=close_all_windows"
          ];
        };
      };
    };
  };
}
