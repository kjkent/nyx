{lib, ...}:
with lib.strings; {
  add_newline = false;
  palette = "default";
  format = concatStrings [
    "[╭](fg:separator)"
    "$status"
    "$directory"
    "$cmd_duration"
    "$line_break"
    "[╰](fg:separator)"
    "$character"
  ];
  palettes.default = {
    prompt_ok = "#8047c1";
    prompt_err = "#e23140";
    icon = "#161514";
    separator = "#35312c";
    background = "#35312c";
    directory = "#9f31e2";
    duration = "#e26f31";
    status = "#e23140";
  };
  character = {
    success_symbol = "[❯](fg:prompt_ok)";
    error_symbol = "[❯](fg:prompt_err)";
  };
  directory = {
    format = "[─](fg:separator)[](fg:directory)[](fg:icon bg:directory)[](fg:directory bg:background)[ $path](bg:background)[](fg:background)";
    truncate_to_repo = false;
    truncation_length = 0;
  };
  status = {
    format = "[─](fg:separator)[](fg:status)[](fg:icon bg:status)[](fg:status bg:background)[ $status](bg:background)[](fg:background)";
    pipestatus = true;
    pipestatus_separator = "-";
    pipestatus_segment_format = "$status";
    pipestatus_format = "[─](fg:separator)[](fg:status)[](fg:icon bg:status)[](fg:status bg:background)[ $pipestatus](bg:background)[](fg:background)";
    disabled = false;
  };
  cmd_duration = {
    format = "[─](fg:separator)[](fg:duration)[󱐋](fg:icon bg:duration)[](fg:duration bg:background)[ $duration](bg:background)[](fg:background)";
    min_time = 1000;
  };
  time = {
    format = "[](fg:duration)[󰥔](fg:icon bg:duration)[](fg:duration bg:background)[ $time](bg:background)[](fg:background)";
    disabled = false;
  };
}