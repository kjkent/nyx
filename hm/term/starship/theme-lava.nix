# Adapted from https://github.com/fredericrous/dotfiles/blob/main/private_dot_config/starship.toml
# TODO: For some reason, git ahead count is not showing
{config, ...}: {
  right_format = "$time";
  palette = "lava";
  palettes.lava = with config.lib.stylix.colors; {
    color0 = "#${base00}"; # to match terminal background
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
    format = "[ $path$read_only ]($style)[](fg:color5)";
    read_only = "  ";
  };

  docker_context = {
    style = "fg:#384D54 bg:#0DB7ED";
    symbol = " ";
    format = "[ $symbol $context ]($style)[](fg:#0DB7ED)";
  };

  git_branch = {
    style = "fg:color0 bg:color6";
    format = "[ $symbol$branch ]($style)[](fg:color6)";
  };

  git_commit = {
    style = "fg:color0 bg:color6";
    format = "[ \\($hash$tag\\) ]($style)[](fg:color6)";
  };

  git_state = {
    style = "fg:color0 bg:color6";
    format = "[ \\($progress_current/$progress_total\\) ]($style)[](fg:color6)";
  };

  git_status = {
    format = "$conflicted$diverged$staged$modified$renamed$deleted$untracked$stashed$behind$ahead";
    staged = "[  $count ](fg:color0 bg:color6)[](fg:color6)";
    modified = "[  $count ](fg:color0 bg:color6)[](fg:color6)";
    renamed = "[  $count ](fg:color0 bg:color6)[](fg:color6)";
    deleted = "[  $count ](fg:color0 bg:color6)[](fg:color6)";
    untracked = "[ ? $count ](fg:color0 bg:color6)[](fg:color6)";
    stashed = "[  $count ](fg:color0 bg:color6)[](fg:color6)";
    behind = "[  $count ](fg:color0 bg:color6)[](fg:color6)";
    ahead = "[  $count ](fg:color0 bg:color6)[](fg:color6)";
    conflicted = "[ 󰞇 $count ](fg:color0 bg:color3)[](fg:color3)";
    diverged = "[  󰙁   $ahead_count  $behind_count ](fg:color3 bg:color7)[](fg:color7)";
  };

  golang = {
    symbol = "󰟓 ";
    style = "fg:color0 bg:#00ADD8";
    format = "[ $symbol$version ]($style)[](fg:#00ADD8)";
  };

  helm = {
    style = "fg:color0 bg:color7";
    format = "[ $symbol$version ]($style)[](fg:color7)";
  };

  kotlin = {
    symbol = "󱈙 ";
    style = "fg:color0 bg:#7F52FF";
    format = "[ $symbol$version ]($style)[](fg:#7F52FF)";
  };

  kubernetes = {
    symbol = "󱃾 ";
    style = "fg:color0 bg:#326CE5";
    format = "[ $symbol$context ]($style)[](fg:#326CE5)";
    disabled = true;
  };

  nodejs = {
    symbol = " ";
    style = "fg:color0 bg:#6CC24A";
    format = "[ $symbol$version ]($style)[](fg:#6CC24A)";
  };

  php = {
    symbol = "󰌟 ";
    style = "fg:color0 bg:color2";
    format = "[ $symbol$version ]($style)[](fg:#AEB2D5)";
  };

  python = {
    symbol = " ";
    style = "fg:#4584b6 bg:#FFDE57";
    format = "[ $symbol$pyenv_prefix$version$virtualenv ]($style)[](fg:#FFDE57)";
  };

  rust = {
    style = "fg:#281C1C bg:#CE422B";
    format = "[ $symbol$version ]($style)[](fg:#CE422B)";
  };

  swift = {
    style = "fg:color0 bg:#F05138";
    format = "[ $symbol$version ]($style)[](fg:#F05138)";
  };

  shlvl = {
    symbol = "󱎞 ";
    style = "fg:color0 bg:color4";
    format = "[ $symbol$shlvl ]($style)[](fg:color4)";
  };

  terraform = {
    style = "fg:color0 bg:#7B42BC";
    format = "[ $symbol$workspace ]($style)[](fg:#7B42BC)";
  };

  username = {
    style_user = "color1";
    style_root = "color3";
    format = "[ $user ](fg:color0 bg:$style)[](fg:$style)";
  };
}
