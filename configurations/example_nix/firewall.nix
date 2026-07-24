{ ... }:

{
  # Base setup for firewall, block everthing except the HTTP's ports
  # Also enable ssh locally only

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 443 ];
  services.openssh.openFirewall = false;
  networking.firewall.extraCommands = ''
    iptables -A nixos-fw -p tcp -s 192.168.15.0/24 --dport 22 -j ACCEPT

    # extraCommands only touches iptables (IPv4). mDNS (.local) commonly
    # resolves to IPv6-only addresses on dual-stack LANs, so without an
    # ip6tables rule here SSH over .local gets silently dropped even
    # though the same connection works fine over a raw IPv4 address.
    # Replace with your LAN's actual /64 prefix.
    ip6tables -A nixos-fw -p tcp -s fd00::/64 --dport 22 -j ACCEPT
  '';
}
