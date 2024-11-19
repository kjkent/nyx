{pkgs, creds, ...}: {
  config = {
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "nyx" ''
        escalate="$([ $UID -eq 0 ] || echo -n sudo)"

        flake_uri="github:${creds.username}/nyx"

        usage() {
          echo ""
          echo "🌙 nyx"
          echo ""
          echo "Usage: nyx <command> [options...]"
          echo ""
          echo "Commands:"
          echo "- rb (flake/#host): Rebuild Nyx, optionally specifying flake & host"
          echo "- check <flake/#host>: Check a local flake builds. Must specify flake."
          echo ""
        }

        if [ "$1" = "rb" ]; then
          (
            "$escalate" nixos-rebuild switch \
              --flake "''${2:-$flake_uri}" \
              --option tarball-ttl 0 \
              --refresh
          )
        elif [ "$1" = "check" ] && [ -n "$2" ]; then
          NIX_IGNORE_UNCLEAN=1 nix flake check --impure "$2"
        else
          usage
        fi
      '')
    ];
  };
}
