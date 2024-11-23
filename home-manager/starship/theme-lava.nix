# Adapted from https://github.com/fredericrous/dotfiles/blob/main/private_dot_config/starship.toml
{ config, ... }:
{
  command_timeout = 1000;
  right_format = "$time";
  palette = "lava";
  palettes.lava = {
    term_bg = "#${config.stylix.base16Scheme.base00}";
    term_fg = "#${config.stylix.base16Scheme.base05}";
    gray = "#939594";
    blergh = "#523333";
    red = "#C00311";
    vermilion = "#ff4b00";
    dark_orange = "#ad4007";
    coral = "#c05303";
    dull_orange = "#d8712c";
    orange = "#ff9400";
    dark_yellow = "#f9a600";
    dull_yellow = "#eb9606";
  };

  character = {
    success_symbol = "[λ](bold fg:orange)";
    error_symbol = "[](bold fg:red)";
  };

  cmd_duration = {
    style = "fg:term_bg bg:dark_yellow";
    format = "[ 󱎫 $duration ]($style)[](fg:dark_yellow)";
  };

  directory = {
    style = "fg:term_bg bg:coral";
    truncate_to_repo = true;
    fish_style_pwd_dir_length = 1;
    format = "[ $path$read_only ]($style)[](fg:coral)";
    read_only = "  ";
  };

  docker_context = {
    style = "fg:term_bg bg:dull_yellow";
    symbol = " ";
    format = "[ $symbol$context ]($style)[](fg:dull_yellow)";
  };

  git_branch = {
    style = "fg:term_bg bg:dull_orange";
    format = "[ $symbol$branch ]($style)[](fg:dull_orange)";
  };

  git_commit = {
    style = "fg:term_bg bg:dull_orange";
    format = "[ \\($hash$tag\\) ]($style)[](fg:dull_orange)";
  };

  git_state = {
    style = "fg:term_bg bg:dull_orange";
    format = "[ \\($progress_current/$progress_total\\) ]($style)[](fg:dull_orange)";
  };

  git_status = {
    style = "fg:term_bg bg:dull_orange";
    format = "[]($style)$conflicted$diverged[$staged$modified$renamed$deleted$untracked$stashed$behind$ahead]($style)[](fg:dull_orange)";
    staged =     " $count ";
    modified =   " $count ";
    renamed =    " $count ";
    deleted =    " $count ";
    untracked =  "? $count ";
    stashed =    " $count ";
    behind =     " $count ";
    ahead =      " $count ";
    conflicted = "[  $count ](fg:red)";
    diverged =   "[ 󰙁   $ahead_count  $behind_count ](fg:red)";
  };

  golang = {
    symbol = "󰟓 ";
    style = "fg:term_bg bg:dull_yellow";
    format = "[ $symbol$version ]($style)[](fg:dull_yellow)";
  };

  helm = {
    style = "fg:term_bg bg:dull_yellow";
    format = "[ $symbol$version ]($style)[](fg:dull_yellow)";
  };

  kotlin = {
    symbol = "󱈙 ";
    style = "fg:term_bg bg:dull_yellow";
    format = "[ $symbol$version ]($style)[](fg:dull_yellow)";
  };

  kubernetes = {
    symbol = "󱃾 ";
    style = "fg:term_bg bg:dark_orange";
    format = "[ $symbol$context ]($style)[](fg:dark_orange)";
    disabled = true;
  };

  nodejs = {
    symbol = " ";
    style = "fg:term_bg bg:dull_yellow";
    format = "[ $symbol$version ]($style)[](fg:dull_yellow)";
  };

  php = {
    symbol = "󰌟 ";
    style = "fg:term_bg bg:dull_yellow";
    format = "[ $symbol$version ]($style)[](fg:dull_yellow)";
  };

  python = {
    symbol = " ";
    style = "fg:term_bg bg:dull_yellow";
    format = "[ $symbol$pyenv_prefix$version$virtualenv ]($style)[](fg:dull_yellow)";
  };

  rust = {
    style = "fg:term_bg bg:dull_yellow";
    format = "[ $symbol$version ]($style)[](fg:dull_yellow)";
  };

  swift = {
    style = "fg:term_bg bg:dull_yellow";
    format = "[ $symbol$version ]($style)[](fg:dull_yellow)";
  };

  shlvl = {
    symbol = "󱎞 ";
    style = "fg:term_bg bg:dark_orange";
    format = "[ $symbol$shlvl ]($style)[](fg:dark_orange)";
  };

  terraform = {
    style = "fg:term_bg bg:dull_yellow";
    format = "[ $symbol$workspace ]($style)[](fg:dull_yellow)";
  };

  username = {
    style_user = "blue";
    style_root = "red";
    format = "[ $user ](fg:term_bg bg:$style)[](fg:$style)";
  };
}
