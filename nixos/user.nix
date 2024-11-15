{
  sshKey,
  gitId,
  user,
  ...
}:
let
  uid = 1000;
  gid = uid;
  groups = [
    "networkmanager"
    "wheel"
    "libvirtd"
    "scanner"
    "lp"
    "docker"
    "render"
  ];
in
{
  config = {
    users = {
      groups.${user} = {
        inherit gid;
      };
      users = {
        ${user} = {
          inherit uid;
          openssh.authorizedKeys.keys = [ sshKey ];
          ignoreShellProgramCheck = true; # Shell is set by Home Manager
          homeMode = "750";
          isNormalUser = true;
          description = gitId;
          extraGroups = groups;
        };
      };
    };
  };
}
