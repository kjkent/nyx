{
  config = {
    nixpkgs = {
      overlays = [
        # 2024-02-24 biome build failure on nixpkgs-unstable
        (_post: pre: {
          inherit (pre.stable) biome;
        })
      ];
    };
  };
}
