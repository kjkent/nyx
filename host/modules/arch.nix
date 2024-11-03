{ lib, ... }: 
{
  config = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}