{
  lib,
  flakeRoot,
  ...
}:
{
   imports = [ "${flakeRoot}/host/modules" ];
}
