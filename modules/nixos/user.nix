{ nixosUser, pkgs, ... }:
let
  uid = 1000;
  gid = uid;
  groups = [
    "adbusers"
    "dialout"
    "kvm"
    "libvirtd"
    "lp"
    "networkmanager"
    "render"
    "scanner"
    "wheel"
  ];
in
{
  config = {
    users = with nixosUser; {
      groups.${username} = {
        inherit gid;
      };
      users = {
        ${username} = {
          inherit uid;
          group = "${username}";
          openssh.authorizedKeys.keys = [ gpg.sshKey ];
          ignoreShellProgramCheck = true; # Shell is set by Home Manager
          shell = pkgs.zsh;
          homeMode = "750";
          isNormalUser = true;
          description = fullName;
          extraGroups = groups;
        };
      };
    };
  };
}
