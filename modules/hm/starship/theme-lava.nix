# Adapted from https://github.com/fredericrous/dotfiles/blob/main/private_dot_config/starship.toml
{ config, ... }:
{
  right_format = "$time";
  palette = "lava";
  palettes.lava = {
    base00 = "#${config.stylix.base16Scheme.base00}";
    base05 = "#${config.stylix.base16Scheme.base05}";
    base01 = "#939594";
    base02 = "#381D00";
    base03 = "#8f000A";
    base04 = "#FF4b00";
    base06 = "#FF6600";
    base07 = "#FF7C00";
    base08 = "#FF9100";
    base09 = "#FFA400";
    base0A = "#FFB600";
    base0B = "#FFC800";
  };

  character = {
    success_symbol = "[λ](bold fg:base08)";
    error_symbol = "[](bold fg:base03)";
  };

  # This one doesn't like `base0B` for some reason.... spooky
  cmd_duration = {
    style = "fg:base00 bg:#FFC800";
    format = "[ 󱎫 $duration ]($style)[](fg:#FFC800)";
  };

  directory = {
    style = "fg:base00 bg:base06";
    truncate_to_repo = true;
    fish_style_pwd_dir_length = 1;
    format = "[ $path$read_only ]($style)[](fg:base06)";
    read_only = "  ";
  };

  docker_context = {
    style = "fg:base00 bg:base0A";
    symbol = " ";
    format = "[ $symbol $context ]($style)[](fg:base0A)";
  };

  git_branch = {
    style = "fg:base00 bg:base07";
    format = "[ $symbol$branch ]($style)[](fg:base07)";
  };

  git_commit = {
    style = "fg:base00 bg:base07";
    format = "[ \\($hash$tag\\)]($style)[](fg:base07)";
  };

  git_state = {
    style = "fg:base00 bg:base07";
    format = "[ \\($progress_current/$progress_total\\)]($style)[](fg:base07)";
  };

  git_status = {
    style = "fg:base00 bg:base07";
    format = "[]($style)$conflicted$diverged[$staged$modified$renamed$deleted$untracked$stashed$behind$ahead]($style)[](fg:base07)";
    staged = "  $count ";
    modified = "  $count ";
    renamed = "  $count ";
    deleted = "  $count ";
    untracked = " ? $count ";
    stashed = "  $count ";
    behind = "  $count ";
    ahead = "  $count ";
    conflicted = "[   $count ](fg:base03 bg:#FFC800)";
    diverged = "[  󰙁   $ahead_count  $behind_count ](fg:base03 bg:#FFC800)";
  };

  golang = {
    symbol = "󰟓 ";
    style = "fg:base00 bg:base0A";
    format = "[ $symbol$version ]($style)[](fg:base0A)";
  };

  helm = {
    style = "fg:base00 bg:base0A";
    format = "[ $symbol$version ]($style)[](fg:base0A)";
  };

  kotlin = {
    symbol = "󱈙 ";
    style = "fg:base00 bg:base0A";
    format = "[ $symbol$version ]($style)[](fg:base0A)";
  };

  kubernetes = {
    symbol = "󱃾 ";
    style = "fg:base00 bg:base04";
    format = "[ $symbol$context ]($style)[](fg:base04)";
    disabled = true;
  };

  nodejs = {
    symbol = " ";
    style = "fg:base00 bg:base0A";
    format = "[ $symbol$version ]($style)[](fg:base0A)";
  };

  php = {
    symbol = "󰌟 ";
    style = "fg:base00 bg:base0A";
    format = "[ $symbol$version ]($style)[](fg:base0A)";
  };

  python = {
    symbol = " ";
    style = "fg:base00 bg:base0A";
    format = "[ $symbol$pyenv_prefix$version$virtualenv ]($style)[](fg:base0A)";
  };

  rust = {
    style = "fg:base00 bg:base0A";
    format = "[ $symbol$version ]($style)[](fg:base0A)";
  };

  swift = {
    style = "fg:base00 bg:base0A";
    format = "[ $symbol$version ]($style)[](fg:base0A)";
  };

  shlvl = {
    symbol = "󱎞 ";
    style = "fg:base00 bg:base04";
    format = "[ $symbol$shlvl ]($style)[](fg:base04)";
  };

  terraform = {
    style = "fg:base00 bg:base0A";
    format = "[ $symbol$workspace ]($style)[](fg:base0A)";
  };

  username = {
    style_user = "blue";
    style_root = "base03";
    format = "[ $user ](fg:base00 bg:$style)[](fg:$style)";
  };
}
