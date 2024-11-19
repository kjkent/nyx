{ creds, pkgs, ...}: {
  config = {
    users = with creds; {
      groups.${username}.gid = gid;
      users = {
        ${username} = {
          inherit uid;
          shell = pkgs.zsh;
          openssh.authorizedKeys.keys = [ gpg.sshKey ];
          ignoreShellProgramCheck = true; # Shell is set by Home Manager
          homeMode = "750";
          isNormalUser = true;
          description = fullName;
          extraGroups = groups;
        };
      };
    };
  };
}
