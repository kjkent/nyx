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
        enableCompletion = true;
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
        initExtra = [
          ''
            # create a zkbd compatible hash;
            # to add other keys to this hash, see: man 5 terminfo
            typeset -g -A key
            
            key[Home]="''${terminfo[khome]}"
            key[End]=''${terminfo[kend]}"
            key[Insert]="''${terminfo[kich1]}"
            key[Backspace]="''${terminfo[kbs]}"
            key[Delete]="''${terminfo[kdch1]}"
            key[Up]="''${terminfo[kcuu1]}"
            key[Down]="''${terminfo[kcud1]}"
            key[Left]="''${terminfo[kcub1]}"
            key[Right]="''${terminfo[kcuf1]}"
            key[PageUp]="''${terminfo[kpp]}"
            key[PageDown]="''${terminfo[knp]}"
            key[Shift-Tab]="''${terminfo[kcbt]}"
            
            # setup key accordingly
            [[ -n "''${key[Home]}"      ]] && bindkey -- "''${key[Home]}"       beginning-of-line
            [[ -n "''${key[End]}"       ]] && bindkey -- "''${key[End]}"        end-of-line
            [[ -n "''${key[Insert]}"    ]] && bindkey -- "''${key[Insert]}"     overwrite-mode
            [[ -n "''${key[Backspace]}" ]] && bindkey -- "''${key[Backspace]}"  backward-delete-char
            [[ -n "''${key[Delete]}"    ]] && bindkey -- "''${key[Delete]}"     delete-char
            [[ -n "''${key[Up]}"        ]] && bindkey -- "''${key[Up]}"         up-line-or-beginning-search
            [[ -n "''${key[Down]}"      ]] && bindkey -- "''${key[Down]}"       down-line-or-history
            [[ -n "''${key[Left]}"      ]] && bindkey -- "''${key[Left]}"       backward-char
            [[ -n "''${key[Right]}"     ]] && bindkey -- "''${key[Right]}"      forward-char
            [[ -n "''${key[PageUp]}"    ]] && bindkey -- "''${key[PageUp]}"     beginning-of-buffer-or-history
            [[ -n "''${key[PageDown]}"  ]] && bindkey -- "''${key[PageDown]}"   end-of-buffer-or-history
            [[ -n "''${key[Shift-Tab]}" ]] && bindkey -- "''${key[Shift-Tab]}"  reverse-menu-complete
            
            # Finally, make sure the terminal is in application mode, when zle is
            # active. Only then are the values from $terminfo valid.
            if (( ''${+terminfo[smkx]} && ''${+terminfo[rmkx]} )); then
            	autoload -Uz add-zle-hook-widget
            	function zle_application_mode_start { echoti smkx }
            	function zle_application_mode_stop { echoti rmkx }
            	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
            	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
            fi
          ''
        ]; 
      };
    };
  };
}
