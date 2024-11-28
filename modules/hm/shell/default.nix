_: {
  imports = [
    ./bat.nix
    ./eza.nix
    ./ls-colors.nix
    ./zsh.nix
  ];
  config = {
    #programs.nix-index.enable = true; # Conflicts with nix-index-database module
  };
}
