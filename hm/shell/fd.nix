_: {
  config = {
    programs.fd = {
      enable = true;
      extraOptions = [ "--absolute-path" ];
      hidden = true;
      ignores = [
        ".git/"
        "node_modules/"
        "/nix/store/"
        "~/.cache/"
      ];
    };
  };
}
