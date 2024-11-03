{ config, user, ... }:
let
  uidStr = builtins.toString config.users.users.${user}.uid;
in
{
  config = {
    environment = {
      variables = {
      };
      sessionVariables  = rec {
        XDG_CACHE_HOME  = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME   = "$HOME/.local/share";
        XDG_STATE_HOME  = "$HOME/.local/state";
        XDG_BIN_HOME    = "$HOME/.local/bin";
        XDG_RUNTIME_DIR = "/run/user/${uidStr}";
        ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
        PATH = [
          "${XDG_BIN_HOME}"
        ];
      };
    };
  };
}
