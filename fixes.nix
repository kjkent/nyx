{
  config = {
    nixpkgs = {
      overlays = [
        # 2024-02-24 biome build failure on nixpkgs-unstable
        (post: pre: {
          biome = pre.stable.biome;
        })
      ];
    };
  };
}
