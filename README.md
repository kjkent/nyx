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

## Acknowledgements

- Nyx is a heavily refactored fork of [ZaneyOS](https://gitlab.com/zaney/zaneyos).
  While the project is restructured and little original host config remains, the user
  config and Wayland styling is still based on ZaneyOS, and this was a great repo to learn from.

- [NixOS Hardware Repo](https://github.com/NixOS/nixos-hardware) for host-specific optimisations.
