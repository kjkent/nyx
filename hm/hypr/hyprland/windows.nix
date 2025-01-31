{
  config.wayland.windowManager.hyprland.settings = {
    dwindle = {
      preserve_split = true;
    };
    windowrulev2 = [
      "float,class:^org.pulseaudio.pavucontrol$"
      # pulseview: normal windows have file title; only matches settings
      "float,initialTitle:^PulseView$"
      "tile,class:^(\.)?scrcpy(-wrapped)?$"
      "stayfocused,title:^$,class:^steam$"
      "minsize 1 1,title:^$,class:^steam$"
      "opacity 0.9 0.7,class:^thunar$"
      "float,title:^(Select|Open|Save) (File|Image|Folder)$"
      "float,title:^Welcome to WebStorm$"
    ];
  };
}
