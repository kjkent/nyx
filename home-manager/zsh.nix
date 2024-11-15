{
  lib,
  config,
  osConfig,
  ...
}:
{
  config = lib.mkIf (osConfig.nyx.shell == "zsh") {
    programs = {
      zsh = {
        enable = true;
        autocd = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        # https://github.com/nix-community/home-manager/issues/5100
        dotDir = ".config/zsh"; # Only takes relative-to-home paths...
        # envExtra = [  ]; # .zshenv
        # initExtra = [  ]; # .zshrc
        history = {
          ignoreSpace = true;
          path = "${config.xdg.stateHome}/zsh_hist"; # However this is either absolute or relative to the dir your shell is started in??
          save = 50000;
          size = 50000;
        };
        # Note - some options don't preserve history order and can lead to
        #  a confusing experience when doing substr searches.
        #  These are history.{ignoreAllDups,expireDuplicatesFirst} (...?)
        historySubstringSearch.enable = true;
        shellAliases = {
          chrome = "google-chrome-stable";
          ll = "eza -Hlhgoat modified --group-directories-first --git --color=auto --icons --no-permissions";
          nap = "systemctl suspend";
          please = "sudo \"$SHELL\" -c \"$(fc -ln -1)\"";
          tmux = "tmux new -As0";
          yklean = "gpg-connect-agent \"scd serialno\" \"learn --force\" /bye";

          pn = "pnpm";
          pndx = "pnpm dlx";
          pnr = "pnpm run";
          pns = "pnpm run start";
          pnu = "pnpm up -Lr";
          pnx = "pnpm exec";

          ### gtfo my $HOME
          wget = "wget --hsts-file=\"$XDG_DATA_HOME\"/wget/hsts";
          yarn = "yarn --use-yarnrc=\"$XDG_CONFIG_HOME\"/yarn/config";
        };
      };
    };
  };
}
