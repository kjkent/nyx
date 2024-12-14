{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      (writeShellScriptBin "goto" ''
        cd "$(dirname "$(realpath "$(which "$1")" )" )"
        $SHELL
      '')

      comma
    ];
    programs = {
      nix-index.enable = true;
      nh = {
        enable = true;
        clean = {
          enable = true;
          dates = "weekly";
          extraArgs = "--keep 5";
        };
      };
    };
  };
}
