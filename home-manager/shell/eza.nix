{ ... }:
{
  config = {
    programs = {
      eza = {
        enable = true;
        extraOptions = [
          "--group-directories-first"
          "--color=auto"
          "--icons"
          #"--across" # for grid view (no -l), sort left-right not top-bottom
          "--hyperlink"
          # long options
          "--header"
          "--octal-permissions"
          "--no-permissions" # disable g=rwx-style perms
          "--modified"
          #"--total-size"   # This slows things down a lot
          "--git"
          "--smart-group" # only show group name if != owner name
        ];
      };
      zsh = {
        shellAliases = rec {
          l = "eza";
          ls = l;
          ll = "${l} --long";
          la = "${l} --all";
          lla = "${ll} --all";
        };
      };
    };
  };
}
