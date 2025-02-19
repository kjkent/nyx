<h1 align="center">🌙 nyx</h1>

> [!WARNING] This is a work-in-progress NixOS flake. While nearing stability,
> it is currently to be avoided unless prepared for your computer to detonate.
> The below text is mostly just a mash of notes to myself.

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

They get easier to understand as time goes on.

Sometimes it can't find a file because:

### Files not staged in Git are ignored

But unstaged _changes_ are.

### Misc

- `builtins.toPath` deprecated in favor of `/. + <string>` for absolute paths,
   and `./. + <string>` for relative paths. jesus christ.

- After an evening debugging hyprland woes, it turns out I was building a three month hyprland build
  because you also have to set the package in HM as well as nix??

## Useful commands

### Nix REPL

Evaluate and recursively print a module/file, while passing lib as an argument:

```Nix
:p import ./syncthingDevices.nix {lib = import <nixpkgs/lib>;}
```

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

Set cache settings (per-setting overwrite, not append):

```shell
attic cache configure system \
  --upstream-cache-key-name cache.nixos.org-1 \
  --upstream-cache-key-name hyprland.cachix.org-1 \
  --upstream-cache-key-name nix-community.cachix.org-1 \
  --upstream-cache-key-name numtide.cachix.org-1 \
  --upstream-cache-key-name cuda-maintainers.cachix.org-1
```

### sops

- For a yaml document with the following structure;

```YAML
protonvpn:
  openvpn:
    username: hello_wolrd
    password: v_secure_password_1
```

sops can access a nested key to extract and decrypt its value, with this command (note the key address syntax):

```Shell
sops --extract '["protonvpn"]["openvpn"]["username"]' --decrypt sops.yaml
```

### nix-sops

- The above syntax doesn't work with sops-nix, which has its own quirks with secrets
  nested within objects.

- Your sops file can be multi-level as above, however `config.sops.secrets.protonvpn.openvpn.username`
  will not work. Use a flat structure and reference the nested key within.

  Note that sops-nix doesn't accept the above sops way of addressing a secret, instead
  levels are denoted by `/`:

```Nix
{inputs, ...}: {
  imports = [inputs.sops-nix.nixosModules.sops];
  config.sops = {
    defaultSopsFile = ./sops.yaml;
    secrets = {
      protonvpn_openvpn_username.key = "protonvpn/openvpn/username";
    };
  };
}
```

- Convert host SSH key (RSA only) to GPG format for SOPS decrypting.
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

## notes:

