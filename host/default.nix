{ host, ... }:
{
  imports = [ 
    ./modules   # Shared/base modules
    ./${host}   # Host-specific config
  ];
}
