{ ... }:
{
  config = {
    fileSystems = {
      "/" = {
        fsType = "xfs";
      };
      "/boot" = {
        fsType = "vfat";
        options = [
          "rw"
          "relatime"
          "fmask=0022"
          "dmask=0022"
          "codepage=437"
          "iocharset=iso8859-1"
          "shortname=mixed"
          "utf8"
          "errors=remount-ro"
        ];
      };
    };
  };
}
