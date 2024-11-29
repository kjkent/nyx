{pkgs, ...}: {
  config.home.packages = with pkgs; [
    (writeShellScriptBin "goto" ''
      cd "$(dirname "$(realpath "$(which "$1")" )" )"
      $SHELL
    '')
    ];
}
