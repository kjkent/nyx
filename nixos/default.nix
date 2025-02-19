{minimalBuild, ...}: {
  imports = [./base] ++ (if minimalBuild then [] else [./extra]);
}
