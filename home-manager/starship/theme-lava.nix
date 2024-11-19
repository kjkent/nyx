# Adapted from https://github.com/fredericrous/dotfiles/blob/main/private_dot_config/starship.toml
{config}: {
  command_timeout = 1000;
  right_format = "$time";
  palette = "lava";
  palettes.lava = {
    black = "#${config.stylix.base16Scheme.base05}";
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

  time = {
    disabled = false;
    format = "[$time](fg:gray)";
  };

  aws = {
    style = "bg:dark_yellow fg:black";
    symbol = "☁ ";
    format = "[]($style)[$symbol$profile]($style)[]($style)";
  };

  character = {
    success_symbol = "[❯](fg:orange)";
    error_symbol = "[✗](fg:vermilion)";
  };

  cmd_duration = {
    style = "fg:black bg:dark_yellow";
    format = "[]($style)[祥$duration]($style)[](fg:dark_yellow)";
  };

  directory = {
    style = "fg:black bg:coral";
    truncate_to_repo = true;
    fish_style_pwd_dir_length = 1;
    format = "[]($style)[$path[$read_only]($style)]($style)[](fg:coral)";
    read_only = " ";
  };

  docker_context = {
    style = "fg:black bg:dull_yellow";
    symbol = "🐳  ";
    format = "[]($style)[$symbol$context]($style)[](fg:dull_yellow)";
  };

  git_branch = {
    style = "fg:black bg:dull_orange";
    format = "[]($style)[$symbol$branch]($style)[](fg:dull_orange)";
  };

  git_commit = {
    style = "fg:black bg:dull_orange";
    format = "[]($style)[\\($hash$tag\\)]($style)[](fg:dull_orange)";
  };

  git_state = {
    style = "fg:black bg:dull_orange";
    format = "[]($style)[\\($progress_current/$progress_total\\)]($style)[](fg:dull_orange)";
  };

  git_status = {
    style = "fg:black bg:dull_orange";
    format = "[]($style)[$conflicted$staged$modified$renamed$deleted$untracked$stashed$ahead_behind]($style)[](fg:dull_orange)";
    conflicted = "[ ](bold fg:88 bg:dull_orange)[  $count ]($style)";
    staged = "[ $count ]($style)";
    modified = "[ $count ]($style)";
    renamed = "[ $count ]($style)";
    deleted = "[ $count ]($style)";
    untracked = "[? $count ]($style)";
    stashed = "[ $count ]($style)";
    ahead = "[ $count ](fg:blergh bg:dull_orange)";
    behind = "[ $count ]($style)";
    diverged = "[ ](fg:88 bg:dull_orange)[ נּ ]($style)[ $ahead_count ]($style)[ $behind_count ]($style)";
  };

  golang = {
    symbol = "ﳑ ";
    style = "fg:black bg:dull_yellow";
    format = "[]($style)[$symbol$version]($style)[](fg:dull_yellow)";
  };

  helm = {
    style = "fg:black bg:dull_yellow";
    format = "[]($style)[$symbol$version]($style)[](fg:dull_yellow)";
  };

  java = {
    symbol = " ";
    style = "fg:black bg:dull_yellow";
    format = "[]($style)[$symbol$version]($style)[](fg:dull_yellow)";
  };

  kotlin = {
    style = "fg:black bg:dull_yellow";
    format = "[]($style)[$symbol$version]($style)[](fg:dull_yellow)";
  };

  kubernetes = {
    style = "fg:black bg:dark_orange";
    format = "[]($style)[$symbol$context]($style)[](fg:dark_orange)";
    disabled = true;
  };

  # memory_usage = {
  #   symbol = " ";
  #   style = "fg:black bg:dark_yellow";
  #   format = "[]($style)[$symbol$ram]($style)[](fg:dark_yellow)";
  #   threshold = 95;
  #   disabled = true;
  # };

  nodejs = {
    style = "fg:black bg:dull_yellow";
    format = "[]($style)[$symbol($version)]($style)[](fg:dull_yellow)";
  };

  ocaml = {
    style = "fg:black bg:dull_yellow";
    format = "[]($style)[$symbol$version]($style)[](fg:dull_yellow)";
  };

  package = {
    disabled = true;
  };

  php = {
    style = "fg:black bg:dull_yellow";
    format = "[]($style)[$symbol$version]($style)[](fg:dull_yellow)";
  };

  python = {
    symbol = " ";
    style = "fg:black bg:dull_yellow";
    format = "[]($style)[$symbol$pyenv_prefix$version$virtualenv]($style)[](fg:dull_yellow)";
  };

  ruby = {
    style = "fg:black bg:dull_yellow";
    symbol = " ";
    format = "[]($style)[$symbol$version]($style)[](fg:dull_yellow)";
  };

  rust = {
    style = "fg:black bg:dull_yellow";
    format = "[]($style)[$symbol$version]($style)[](fg:dull_yellow)";
  };

  scala = {
    style = "fg:black bg:dull_yellow";
    format = "[]($style)[$symbol$version]($style)[](fg:dull_yellow)";
  };

  swift = {
    style = "fg:black bg:dull_yellow";
    format = "[]($style)[$symbol$version]($style)[](fg:dull_yellow)";
  };

  shell = {
    fish_indicator = "";
    bash_indicator = "bash ";
    zsh_indicator = "zsh ";
    powershell_indicator = "";
    format = "[$indicator](fg:dark_orange)";
    disabled = true;
  };

  shlvl = {
    symbol = " ";
    style = "fg:black bg:dark_orange";
    format = "[]($style)[$symbol$shlvl]($style)[](fg:dark_orange)";
    disabled = true;
  };

  terraform = {
    style = "fg:black bg:dull_yellow";
    format = "[]($style)[$symbol$workspace]($style)[](fg:dull_yellow)";
  };

  username = {
    style_user = "blue";
    style_root = "red";
    format = "[](fg:black bg:$style)[$user](fg:black bg:$style)[](fg:$style)";
  };

  vagrant = {
    style = "fg:black bg:dull_yellow";
    format = "[]($style)[$symbol$version]($style)[](fg:dull_yellow)";
  };
}
