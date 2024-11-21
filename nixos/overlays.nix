_:
{
  config = {
    nixpkgs.overlays = [
      (_: prev: {lib = prev.lib // (import ./lib prev);})
    ];
  };
}
