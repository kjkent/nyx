# 🌃 nyx

A work-in-progress NixOS flake.

## Installation

NixOS must already be installed on the target machine.

1. Clone this repo: `git clone https://github.com/kjkent/nyx.git ~/.config/nyx`
2. Amend flake to fit users and hosts (like most Nix documentation, these instructions are a work-in-progress)
3. Rebuild NixOS: `sudo nixos-rebuild --flake ~/.config/nyx/#<hostname>`

## Post-install

Nyx provides the `nyx` cli utility for basic maintenance.

- `nyx rb` - Rebuild host. `nyx rb <hostname>` to rebuild another host.
- `nyx up` - Update flake dependencies.
- `nyx cd` - cd to flake directory.


## Nix quirks encountered so far:

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

Nyx is a heavily refactored fork of [ZaneyOS](https://gitlab.com/zaney/zaneyos).
While the project is restructured and little original host config remains, the user
config and Wayland styling is still based on ZaneyOS.
