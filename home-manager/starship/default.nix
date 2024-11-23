{ config, ... }:
{
  config = {
    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = import ./theme-lava.nix { inherit config; };
    };
  };
}
