{nixosUser, ...}:
with nixosUser; {
  config = {
    programs.git = {
      enable = true;
      userName = "${fullName} (${username})";
      userEmail = email;
      diff-so-fancy.enable = true;
      lfs.enable = true;

      signing = {
        key = gpg.fingerprint;
        signByDefault = true;
      };

      maintenance = {
        enable = false;
        repositories = []; # Absolute paths
      };

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        color.ui = true;

        "diff \"font\"" = {
          textconv = "sfddiff";
          binary = true;
        };

        "diff \"asc\"" = {
          textconv = ''f() { gpg --list-packets < "$1" | grep -v "^# off="; }; f'';
        };
      };
      includes = [
        # `contents` == `git.extraConfig`
        {
          condition = "hasconfig:remote.*.url:ssh://aur@aur.archlinux.org/**";
          contents = {
            init.defaultBranch = "master";
            pull.ff = "only";
          };
        }
      ];
      attributes = [
        "package-lock.json -diff"
        "pnpm-lock.yaml    -diff"
        "flake.lock        -diff"
        "*.asc              diff=asc"
        "*.[ot]tf           diff=font"
        "*.woff             diff=font"
        "*.woff2            diff=font"
      ];
      aliases = {
        a = "add";
        aa = "add -A";
        b = "branch";
        ba = "branch -a";
        bd = "branch -d";
        bD = "branch -D";
        ch = "checkout";
        chb = "checkout -b";
        cl = "clone";
        cgh = "!git clone https://github.com/$1.git";
        co = "commit -m";
        ca = "commit --amend --no-edit";
        can = "commit --amend --no-edit --no-gpg-sign";
        d = "diff";
        ds = "diff --staged";
        f = "fetch";
        # Add all files from previous commit, amend, force-push. Dangerous!
        ffs = ''!cf="$(git show --name-only --oneline --name-only --pretty=)"; git add "''${cf[@]}" && git commit --amend --no-edit && git push --force'';
        l = "log";
        ps = "push";
        pl = "pull";
        plng = "pull --no-gpg-sign";
        rem = "remote -vv";
        rb = "rebase";
        rba = "rebase --abort";
        rbc = "rebase --continue";
        s = "status";
        ss = "status --staged";
      };
    };
  };
}
