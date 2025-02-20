#!/usr/bin/env bash
set -eo pipefail
dir0=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
alias sudo="$([ "$UID" = "0" ] && command sudo)"

esp_name="nyx_esp"
crypt_name="nyx_crypt"
root_name="nyx_root"

usage() {
  echo "NixOS installation bootstrap"
  echo "----------------------------"
  echo "Usage: ${0:-bootstrap.sh} <hostname> <device>"
  echo "  E.g. ${0:-bootstrap.sh} kdes /dev/nvme0n1"

  exit "${1:-0}"
}

host_name="${1:?$(usage 1)}"
disk="${2:?$(usage 1)}"

# Install needed packages
sudo nix-env -iA \
  nixos.git \
  nixos.git-crypt \
  nixos.gnupg \
  nixos.pinentry-all \
  nixos.sops

# Partition disk. 2GB ESP & remaining root.
sudo sgdisk \
  --zap-all \
  --align-end \
  --new=1:0:+2G --typecode=1:ef00 \
  --largest-new=2 --typecode=2:8304 \
  --verify \
  "$disk"

# Format LUKS partition, decrypt, set perf tweaks
sudo cryptsetup luksFormat --label "$crypt_name" "${disk}p2"

# All ops from here need to be cleaned up
cleanup() {
  sudo umount --force --recursive /mnt || 
    (sudo umount --force /mnt/boot; sudo umount --force /mnt)
  sleep 2
  sudo cryptsetup close "$root_name"
}
trap cleanup EXIT

#...and continue
sudo cryptsetup open \
  --allow-discards \
  --perf-no_read_workqueue \
  --perf-no_write_workqueue \
  --persistent \
  "${disk}p2" \
  "$root_name"

# Format & mount root
sudo mkfs.xfs -L "$root_name" /dev/mapper/"$root_name"
sudo mkdir -p /mnt
sudo mount /dev/mapper/"$root_name" /mnt

# Format & mount ESP
sudo mkfs.vfat -F 32 -n "$esp_name" --codepage=437 "${disk}p1"
sudo mkdir -p /mnt/boot
sudo mount "${disk}p1" /mnt/boot

# Ensure git-crypted files are decrypted (here we goooo)
echo "pinentry-program $(which pinentry-gnome3)" > ~/.gnupg/gpg-agent.conf
gpgconf -R 
gpg-connect-agent reloadagent /bye
git-crypt unlock

# Install host SSH keys (for sops-nix)
sshcfg="/mnt/etc/ssh"
sudo systemctl stop sshd
sudo mkdir -p "$sshcfg"

for type in "ed25519" "rsa"; do
  echo "Extracting $type private key"
  sops --decrypt \
       --extract \
       '["sshd"]["priv_keys"]["'"$host_name"'"]["'"$type"'"]' \
       "$(dirname "$dir0")/sops/sops.yaml" | \
       sudo tee "$sshcfg/ssh_host_${type}_key" > /dev/null

  echo "Extracting $type public key"
  sops --decrypt \
       --extract \
       '["sshd"]["pub_keys"]["'"$host_name"'"]["'"$type"'"]' \
       "$(dirname "$dir0")/sops/sops.yaml" | \
       sudo tee "$sshcfg/ssh_host_${type}_key.pub" > /dev/null
done

sudo chown -R root:root "$sshcfg"
sudo chmod 0644 "$sshcfg"
sudo find "$sshcfg" -xdev -type f -name "ssh_host*key.pub" -exec chmod 0644 {} \;
sudo find "$sshcfg" -xdev -type f -name "ssh_host*key" -exec chmod 0600 {} \;

# send it
#sudo nixos-install \
#  --flake "$dir0/#${host_name}" \
#  --impure \
#  --no-channel-copy \
#  --verbose

