#!/usr/bin/env bash

if [ "$UID" -eq 0 ]; then
  echo "Do not run this script as root, run it as a normal user."
  exit 1
fi

sudo nix-env -iA nixos.{gnupg,git-crypt,git,pinentry-all,sops}

mkdir -p ~/.gnupg

cat << EOF > ~/.gnupg/gpg-agent.conf
pinentry-program $(which pinentry-gnome3)
enable-ssh-support
EOF

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

gpg --command-fd 0 --pinentry-mode=loopback --card-edit << EOF
fetch
quit
EOF

gpg-connect-agent updatestartuptty /bye
gpg-connect-agent reloadagent /bye
gpgconf -R

# Seems to jog gpg into recognising this yubikey contains the imported keys
gpg --card-status > /dev/null

cat << 'EOF'
Trust your imported key with...

- `gpg --edit-key <key or user ID>`
- `trust`
- `5`
- `y`
- `quit`

...and then `ssh` / `git` operations should work!
EOF
