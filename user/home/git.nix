{ gitId, email, gpgFingerprint, ... }:
{
  config = {
    programs.git = {
      enable = true;
      userName = gitId;
      userEmail = email;
      diff-so-fancy.enable = true;
      lfs.enable = true;

      signing = {
        key = gpgFingerprint;
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
          textconv = "f(){gpg --list-packets < \"$1\" | grep -v \"^# off=\";}; f";
        };

      };
      includes = [ # `contents` == `git.extraConfig`
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
        bd = "branch -d";
        bD = "branch -D";
        ch = "checkout";
        chb = "checkout -b";
        cl = "clone";
        co = "commit -m";
        cong = "commit --no-gpg-sign -m";
        d = "diff";
        ds = "diff --staged";
        f = "fetch";
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
