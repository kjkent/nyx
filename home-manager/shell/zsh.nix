{
  config,
  creds,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  zshInUse = osConfig.users.users.${creds.username}.shell == pkgs.zsh;
in
{
  config = lib.mkIf zshInUse {
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autocd = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        # https://github.com/nix-community/home-manager/issues/5100
        dotDir = ".config/zsh"; # Only takes relative-to-home paths...
        history = {
          ignoreSpace = true;
          path = "${config.xdg.stateHome}/zsh_hist"; # However this is either absolute or relative to the dir your shell is started in??
          save = 50000;
          size = 50000;
        };
        # Note - some options don't preserve history order and can lead to
        #  a confusing experience when doing substr searches.
        #  These are history.{ignoreAllDups,expireDuplicatesFirst} (...?)
        historySubstringSearch = {
          enable = true;
          searchUpKey = "$terminfo[kcuu1]";
          searchDownKey = "$terminfo[kcud1]";
        };
        shellAliases = rec {
          chrome = "google-chrome-stable";
          nap = "systemctl suspend";
          please = "sudo \"$SHELL\" -c \"$(fc -ln -1)\"";
          ffs = please;
          tmux = "tmux new -As0";
          yklean = "gpg-connect-agent \"scd serialno\" \"learn --force\" /bye";

          ### gtfo my $HOME
          wget = "wget --hsts-file=\"$XDG_DATA_HOME\"/wget/hsts";
          yarn = "yarn --use-yarnrc=\"$XDG_CONFIG_HOME\"/yarn/config";
        };
        initExtra = ''
          # create a zkbd compatible hash;
          # to add other keys to this hash, see: man 5 terminfo
          typeset -g -A key

          autoload -U history-substring-search-up
          autoload -U history-substring-search-down
          zle -N history-substring-search-up
          zle -N history-substring-search-down

          key[Home]="''${terminfo[khome]}"
          key[End]="''${terminfo[kend]}"
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
          [[ -n "''${key[Up]}"        ]] && bindkey -- "''${key[Up]}"         history-substring-search-up
          [[ -n "''${key[Down]}"      ]] && bindkey -- "''${key[Down]}"       history-substring-search-down
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

          # Add a newline between commands
          # Fixes starship newline=true opening with line break
          precmd() { precmd() { echo } }
        '';
      };
    };
  };
}
