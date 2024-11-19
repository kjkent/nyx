{lib, ...}: {
  config = {
    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = lib.importTOML ./lava.toml; 
    };
  };
}
