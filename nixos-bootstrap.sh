#!/usr/bin/env bash
set -eo pipefail
dir0=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
alias sudo="$([ "$UID" = "0" ] && command sudo)"

host_name="$1"
disk="$2"
esp_name="nyx_esp"
crypt_name="nyx_crypt"
root_name="nyx_root"

if ([ "$1" != "klap" ] && [ "$1" != "kdes" ]) || [[ "$2" != "/dev/"* ]]; then
	echo "NixOS installation bootstrap"
	echo "----------------------------"
	echo "Usage: $0 <hostname> <device>"
	echo "E.g. $0 kdes /dev/nvme0n1"
else
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
	sudo cryptsetup open \
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
	sudo mkfs.vfat -F 32 -n "$esp_name" "${disk}p1"
	sudo mkdir -p /mnt/boot
	sudo mount "${disk}p1" /mnt/boot

	# send it
	sudo nixos-install \
		--flake "$dir0/#${host_name}" \
		--impure \
		--no-channel-copy \
		-v -v -v
fi

