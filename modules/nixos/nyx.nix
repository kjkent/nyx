{ nixosUser, pkgs, ... }:
let
  host = "github";
  repo = "${nixosUser.username}/nyx";
  flakeUri = "${host}:${repo}";
  sshUri = "git@${host}.com/${repo}.git";
  httpsUri = "https://${host}.com/${repo}.git";
in
{
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
          echo "- rb: Fetch Nyx from GitHub and rebuild local machine"
          echo "- check (dir): Check a local flake builds."
          echo "- clone (https|ssh) (dir): Clone via (https|ssh) to (dir). Default ssh + pwd"
          echo "- up (dir): Update and flake.lock in local Nyx repo"
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
          set -e

          build_dir="$(mktemp -d)"

          git clone "$https_uri" "$build_dir"
          cd "$build_dir"

          echo "Unlocking git-crypt!"
          echo "Look out for authentication prompts."
          git-crypt unlock

          "$escalate" nixos-rebuild --option tarball-ttl 0 --refresh --flake ./ switch

          rm -rf "$build_dir"
        elif [ "$1" = "check" ]
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
        elif [ "$1" = "up" ]
        then
          up_dir="''${2:-$PWD}"

          cd "$up_dir" &&
          nix flake update && 
          nix run github:fzakaria/nix-auto-follow -- -i && 
          nix run github:fzakaria/nix-auto-follow -- -c
        else
          usage
        fi
      '')
    ];
  };
}
