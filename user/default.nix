{ sshKey, gitId, pkgs, user, flakeRoot, ... }:
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
  imports = [
    "${flakeRoot}/user/modules"
  ];
  
  config = {
    users = {
      groups.${user} = { inherit gid; };
      users = {
        ${user} = {
          inherit uid;
          openssh.authorizedKeys.keys = [ sshKey ];
          homeMode = "750";
          isNormalUser = true;
          description = gitId;
          extraGroups = groups;
          shell = pkgs.zsh;
          ignoreShellProgramCheck = true;
          packages = [ ];
        };
      };
    };
  };
}
