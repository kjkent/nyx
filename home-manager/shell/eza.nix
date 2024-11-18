{...}: {
  config = {
    programs = {
      eza = {
        enable = true;
        extraOptions = [
          "--group-directories-first"
          "--color=auto"
          "--icons"
          # long options
          "--header"
          "--links"
          "--octal-permissions"
          "--no-permissions" # disable g=rwx-style perms
          "--modified"
          "--total-size"
          "--git"
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
