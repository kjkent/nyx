_: {
  config = {
    programs = {
      eza = {
        enable = true;
        extraOptions = [
          "--group-directories-first"
          "--icons"
          #"--across" # for grid view (no -l), sort left-right not top-bottom
          "--hyperlink"
          # long options
          "--header"
          "--octal-permissions"
          "--no-permissions" # disable ogu=rwx-style perms
          "--modified"
          #"--total-size"   # This slows things down a lot
          "--git"
          "--smart-group" # only show group name if != owner name
        ];
      };
      zsh = {
        shellAliases = rec {
          ll = "eza --long";
          ls = ll;
          la = "${ll} --all";
        };
      };
    };
  };
}
