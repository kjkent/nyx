_: {
  imports = [
    ./bat.nix
    ./eza.nix
    ./fastfetch.nix
    ./fd.nix
    ./foot.nix
    ./ghostty.nix
    ./ls-colors.nix
    ./starship
    ./tldr.nix
    ./zsh.nix
  ];

  config = {
    programs.urxvt.enable = true;
  };
}
