{ creds, pkgs, ...}: {
  config = {
    users = with creds; {
      groups.${username}.gid = gid;
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
