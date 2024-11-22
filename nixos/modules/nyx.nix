# TODO: Refactor to clone to tmpdir, then git-crypt unlock for build-time secrets

{pkgs, creds, ...}: let
  host = "github";
  repo = "${creds.username}/nyx";
  flakeUri = "${host}:${repo}";
  sshUri = "git@${host}.com/${repo}.git";
  httpsUri = "https://${host}.com/${repo}.git";
in {
  config = {
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "nyx" ''
        escalate="$([ $UID -eq 0 ] || echo -n sudo)"

        flake_uri="${flakeUri}"
        ssh_uri="${sshUri}"
        https_uri="${httpsUri}"

        usage() {
          echo ""
          echo "🌙 nyx"
          echo ""
          echo "Usage: nyx <command> [options...]"
          echo ""
          echo "Commands:"
          echo "- rb (flake/#host): Rebuild Nyx, optionally specifying flake & host"
          echo "- check <flake/#host>: Check a local flake builds. Must specify flake."
          echo "- clone (https|ssh) (dir): Clone via (https|ssh) to (dir). Default ssh + pwd"
          echo ""
        }

        resolve_dest() {
          [ -d "$(dirname $1)" ] && echo -n "$1"
        }

        prot_uri() {
          if [ "$1" = "https" ]; then 
            echo -n "$https_url"
          elif [ "$1" = "ssh" ]; then 
            echo -n "$ssh_uri"
          else
            usage && exit 1
          fi
        }

        if [ "$1" = "rb" ]
        then
          "$escalate" nixos-rebuild switch \
            --flake "''${2:-$flake_uri}" \
            --option tarball-ttl 0 \
            --refresh
        elif [ "$1" = "check" ] && [ -n "$2" ]
        then
          NIX_IGNORE_UNCLEAN=1 nix flake check --impure "$2"
        elif [ "$1" = "clone" ]
        then
          if [[ "$(resolve_dest $3)" ]]
          then
            git clone "$(prot_uri $2)" "$(resolve_dest $3)"
          else
            git clone "$ssh_uri" "$(resolve_dest $2)" 
          fi
        else
          usage
        fi
      '')
    ];
  };
}
