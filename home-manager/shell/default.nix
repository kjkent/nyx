_: {
  imports = [
    ./bat.nix
    ./eza.nix
    ./ls-colors.nix
    ./zsh.nix
  ];
  config = {
    programs.nix-index.enable = true; # works with nix-index-database module
  };
}
