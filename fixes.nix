{
  config = {
    nixpkgs = {
      overlays = let
        useStable = pname: (_post: pre: {${pname} = pre.stable.${pname};});
      in [
        (useStable "biome") # 20250224 build failure
        (useStable "protonmail-desktop") # 20250228 segfault
      ];
    };
  };
}
