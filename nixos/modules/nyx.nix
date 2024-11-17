{
  lib,
  pkgs,
  user,
  config,
  ...
}:
{
  options =
    with lib;
    with types;
    {
      nyx = {
        shell = mkOption {
          type = enum [
            "bash"
            "fish"
            "zsh"
          ];
          default = "zsh";
        };
        terminal = mkOption {
          type = str;
          default = "foot";
        };
        browser = mkOption {
          type = str;
          default = "firefox";
        };
      };
    };
  config = with config.nyx; {
    users.users.${user}.shell = pkgs.${shell};
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "nyx" ''
        escalate="$([ $UID -eq 0 ] || echo -n sudo)"
        
        flake_uri="github:kjkent/nyx"

        usage() {
          echo ""
          echo "🌙 nyx"
          echo ""
          echo "Usage: nyx <command> [options]"
          echo ""
          echo "rb (flake/#host): Rebuild Nyx, optionally specifying flake & host"
          echo ""
        }

        if [ "$1" = "rb" ]; then
          (
            "$escalate" nixos_rebuild switch \
              --flake "''${2:-$flake_uri}" \
              --option tarball-ttl 0 \
              --refresh
          )
        else
          usage
        fi
      '')
    ];
  };
}
