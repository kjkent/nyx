#!/usr/bin/env bash

if [ "$UID" -eq 0 ]; then
  echo "Do not run this script as root, run it as a normal user."
  exit 1
fi

sudo nix-env -iA nixos.{gnupg,git-crypt,git,pinentry-all,sops,gnused,gawk}

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

keyfpr="$(gpg -k --with-colons | awk '/^fpr:/{print $0; exit}' | cut -d ':' -f 10)"
gpg --command-fd 0 --edit-key "$keyfpr" << EOF
trust
5
y
quit
EOF

# Seems to jog gpg into recognising this yubikey contains the imported keys
gpg --card-status > /dev/null

gpg-connect-agent updatestartuptty /bye
gpg-connect-agent reloadagent /bye
gpgconf -R
