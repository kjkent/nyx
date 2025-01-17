<h1 align="center">🌙 nyx</h1>

A work-in-progress NixOS flake.

## Nix quirks encountered so far:

Tip! Nix copies your flake source to the store at build time, but it can be
hard to find. It will end in `-source`, so can be found with 
`ls -l /nix/store | grep -E '-store$'`. This flake however links the source 
and the nixpkgs at the time to `/etc/self`.

### String interpolation quoting

```Nix
# Good
modules = [ ./host/${host}.nix ];
imports = [ "${flakeRoot}/host/modules" ];
groups."${user}" = { inherit gid; };
groups.${user} = { inherit gid; };

# Bad
imports = [ "${flakeRoot}"/host/modules ];
modules = [ ${flakeRoot}/host/${host}.nix ];
```

### Cryptic error messages

The above string interpolation quoting can yield an error like

```nix
error: opening file '/nix/store/nwxxmnx1brixq37paj3fs04flc63cqrx-source/host/default.nix': No such file or directory
```
Not helpful in a multi-file config, sometimes the filename can be found in a trace but often not.

Sometimes it can't find a file because:

### Files not staged in Git are ignored

Because why not _shrug_. God damnit.

## Useful commands

### Attic

Login:

```shell
attic login system <url: https://hostname.tld> <token>
```

Create cache:

```shell
attic cache create \
    --priority 44 \
    --upstream-cache-key-name hyprland.cachix.org-1 \
    --upstream-cache-key-name nix-community.cachix.org-1 \
    --upstream-cache-key-name numtide.cachix.org-1 \
  system
```

Push to cache:

```shell
attic push system /run/current-system
```

Get cache info:

```shell
attic cache info system
```

Reconfigure cache attribute:

```shell
attic cache configure system \
  --upstream-cache-key-name cache.nixos.org-1 \
  --upstream-cache-key-name hyprland.cachix.org-1 \
  --upstream-cache-key-name nix-community.cachix.org-1 \
  --upstream-cache-key-name numtide.cachix.org-1 \
  --upstream-cache-key-name cuda-maintainers.cachix.org-1
```

### nix-sops

Convert host SSH key (RSA only) to GPG format for SOPS decrypting.
The saved ascii-armored pubkey must be imported: `gpg --import <file>`.
`ssh-to-pgp` will also output (to stdout) the key's fingerprint,
for inclusion in `.sops.yaml`.

```shell
sudo ssh-to-pgp \
  -i /etc/ssh/ssh_host_rsa_key \
  -name "$HOST (host SSH key)" \
  -email "root@$HOST" \
  -comment "" \
  > "ssh_$HOST.pub.asc"
```

## Acknowledgements

- Nyx is a heavily refactored fork of [ZaneyOS](https://gitlab.com/zaney/zaneyos).
  While the project is restructured and little original host config remains, the user
  config and Wayland styling is still based on ZaneyOS, and this was a great repo to learn from.

- [NixOS Hardware Repo](https://github.com/NixOS/nixos-hardware) for host-specific optimisations.

- [LGUG2Z](https://lgug2z.com/articles/deploying-a-cloudflare-r2-backed-nix-binary-cache-attic-on-fly-io/)
  for info on setting up a Nix binary cache within docker, using [attic](https://github.com/zhaofengli/attic)
