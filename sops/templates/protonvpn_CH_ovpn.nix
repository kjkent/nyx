{config, lib, ...}: {sops.templates."protonvpn_CH_ovpn".content = let
getSecret = id: lib.attrsets.attrByPath 
  [ "protonvpn_openvpn_${id}" ] "undefined :(" config.sops.placeholder;
in ''
# ==============================================================================
# Copyright (c) 2023 Proton AG (Switzerland)
# Email: contact@protonvpn.com
#
# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR # OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
# ==============================================================================

# If you are a paying user you can also enable the ProtonVPN ad blocker (NetShield) or Moderate NAT:
# Use: "${getSecret "username"}+f1" as username to enable anti-malware filtering
# Use: "${getSecret "username"}+f2" as username to additionally enable ad-blocking filtering
# Use: "${getSecret "username"}+nr" as username to enable Moderate NAT
# Note that you can combine the "+nr" suffix with other suffixes.

client
dev tun
proto udp

remote 146.70.226.226 4569
remote 185.159.157.13 4569
remote 138.199.6.179 80
remote 146.70.226.194 51820
remote 149.88.27.193 4569
remote 149.88.27.193 1194
remote 149.88.27.233 5060
remote 185.159.157.129 51820
remote 146.70.226.226 5060
remote 185.230.125.34 5060
remote 185.159.157.129 5060
remote 149.88.27.206 51820
remote 146.70.226.226 51820
remote 185.159.157.129 80
remote 149.88.27.234 4569
remote 185.230.125.2 4569
remote 149.88.27.193 51820
remote 146.70.226.194 4569
remote 149.88.27.206 1194
remote 185.159.157.129 1194
remote 146.70.226.194 80
remote 138.199.6.179 4569
remote 185.230.125.2 51820
remote 149.88.27.233 4569
remote 185.230.125.34 80
remote 149.88.27.234 80
remote 146.70.226.226 80
remote 185.230.125.2 1194
remote 138.199.6.179 1194
remote 79.127.184.1 1194
remote 185.159.157.13 5060
remote 149.88.27.233 51820
remote 146.70.226.226 1194
remote 185.230.125.34 4569
remote 79.127.184.1 4569
remote 149.88.27.233 1194
remote 185.230.125.2 5060
remote 79.127.184.1 51820
remote 185.159.157.13 51820
remote 79.127.184.1 80
remote 149.88.27.233 80
remote 146.70.226.194 1194
remote 185.159.157.129 4569
remote 146.70.226.194 5060
remote 149.88.27.234 51820
remote 149.88.27.193 5060
remote 149.88.27.193 80
remote 185.230.125.2 80
remote 185.159.157.13 80
remote 149.88.27.206 4569
remote 149.88.27.234 5060
remote 185.230.125.34 51820
remote 79.127.184.1 5060
remote 138.199.6.179 51820
remote 149.88.27.206 5060
remote 185.159.157.13 1194
remote 149.88.27.234 1194
remote 138.199.6.179 5060
remote 185.230.125.34 1194
remote 149.88.27.206 80
server-poll-timeout 20

remote-random
resolv-retry infinite
nobind

cipher AES-256-GCM

setenv CLIENT_CERT 0
tun-mtu 1500
mssfix 0
persist-key
persist-tun

reneg-sec 0

remote-cert-tls server

<auth-user-pass>
${getSecret "username"}
${getSecret "password"}
</auth-user-pass>

script-security 2
up /etc/openvpn/update-resolv-conf
down /etc/openvpn/update-resolv-conf

fast-io
sndbuf 512000
rcvbuf 512000
txqueuelen 2000

dhcp-option DOMAIN-ROUTE .

<ca>
${getSecret "ca_cert"}
</ca>

<tls-crypt>
${getSecret "tls_key"}
</tls-crypt>
'';}
