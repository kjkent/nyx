# Adapted from https://github.com/fredericrous/dotfiles/blob/main/private_dot_config/starship.toml
{ config, ... }:
{
  right_format = "$time";
  palette = "lava";
  palettes.lava = {
    color0 = "#${config.stylix.base16Scheme.base00}";
    color1 = "#1323D1";
    color2 = "#790F99";
    color3 = "#E61300";
    color4 = "#FF4b00";
    color5 = "#FF6600";
    color6 = "#FF9100";
    color7 = "#FFB600";
  };

  character = {
    success_symbol = "[λ](bold fg:color6)";
    error_symbol = "[](bold fg:color3)";
  };

  # This one doesn't like `color7` for some reason.... spooky
  cmd_duration = {
    style = "fg:color0 bg:color7";
    format = "[ 󱎫 $duration ]($style)[](fg:color7)";
  };

  directory = {
    style = "fg:color0 bg:color5";
    truncate_to_repo = true;
    fish_style_pwd_dir_length = 1;
    format = "[ $path$read_only ]($style)[](fg:color5)";
    read_only = "  ";
  };

  docker_context = {
    style = "fg:color0 bg:color7";
    symbol = " ";
    format = "[ $symbol $context ]($style)[](fg:color7)";
  };

  git_branch = {
    style = "fg:color0 bg:color6";
    format = "[ $symbol$branch ]($style)[](fg:color6)";
  };

  git_commit = {
    style = "fg:color0 bg:color6";
    format = "[ \\($hash$tag\\)]($style)[](fg:color6)";
  };

  git_state = {
    style = "fg:color0 bg:color6";
    format = "[ \\($progress_current/$progress_total\\)]($style)[](fg:color6)";
  };

  git_status = {
    style = "fg:color0 bg:color6";
    format = "[]($style)$conflicted$diverged[$staged$modified$renamed$deleted$untracked$stashed$behind$ahead]($style)[](fg:color6)";
    staged = "  $count ";
    modified = "  $count ";
    renamed = "  $count ";
    deleted = "  $count ";
    untracked = " ? $count ";
    stashed = "  $count ";
    behind = "  $count ";
    ahead = "  $count ";
    conflicted = "[   $count ](fg:color3 bg:color7)";
    diverged = "[  󰙁   $ahead_count  $behind_count ](fg:color3 bg:color7)";
  };

  golang = {
    symbol = "󰟓 ";
    style = "fg:color0 bg:color1";
    format = "[ $symbol$version ]($style)[](fg:color7)";
  };

  helm = {
    style = "fg:color0 bg:color7";
    format = "[ $symbol$version ]($style)[](fg:color7)";
  };

  kotlin = {
    symbol = "󱈙 ";
    style = "fg:color0 bg:color7";
    format = "[ $symbol$version ]($style)[](fg:color7)";
  };

  kubernetes = {
    symbol = "󱃾 ";
    style = "fg:color0 bg:color1";
    format = "[ $symbol$context ]($style)[](fg:color4)";
    disabled = true;
  };

  nodejs = {
    symbol = " ";
    style = "fg:color0 bg:green";
    format = "[ $symbol$version ]($style)[](fg:color7)";
  };

  php = {
    symbol = "󰌟 ";
    style = "fg:color0 bg:color2";
    format = "[ $symbol$version ]($style)[](fg:color7)";
  };

  python = {
    symbol = " ";
    style = "fg:color0 bg:color7";
    format = "[ $symbol$pyenv_prefix$version$virtualenv ]($style)[](fg:color7)";
  };

  rust = {
    style = "fg:color0 bg:color3";
    format = "[ $symbol$version ]($style)[](fg:color7)";
  };

  swift = {
    style = "fg:color0 bg:color7";
    format = "[ $symbol$version ]($style)[](fg:color7)";
  };

  shlvl = {
    symbol = "󱎞 ";
    style = "fg:color0 bg:color4";
    format = "[ $symbol$shlvl ]($style)[](fg:color4)";
  };

  terraform = {
    style = "fg:color0 bg:color7";
    format = "[ $symbol$workspace ]($style)[](fg:color7)";
  };

  username = {
    style_user = "color1";
    style_root = "color3";
    format = "[ $user ](fg:color0 bg:$style)[](fg:$style)";
  };
}
