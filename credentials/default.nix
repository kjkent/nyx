rec {
  username = "kjkent";
  fullName = "Kristopher James Kent";
  email = "kris@kjkent.dev";
  uid = 1000;
  gid = uid;
  groups = [
    "adbusers"
    "dialout"
    "kvm"
    "libvirtd"
    "lp"
    "networkmanager"
    "render"
    "scanner"
    "wheel"
  ];
  gpg = {
    fingerprint = "F0954AC5C9A90C70794CCA88B02F66B6C1A75107";
    keygrip = "22638115B2A44BACFCC08B658945BB46BC925523";
    pubKey = ./gpg.pub.asc;
    sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVd7FB3ohh9ZJ9HWhDbYe0yPHxggkrELqPGxsXwDo6W openpgp:0x323C7F61";
  };
}
