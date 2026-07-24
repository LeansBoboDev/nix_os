{ ... }:

{
  # Base setup for firewall, block everthing except the HTTP's ports
  # Also enable ssh locally only

  networking.firewall.enable = true;
  # 443 HTTPS
  networking.firewall.allowedTCPPorts = [ 443 ];
  # 5353 mdns
  networking.firewall.allowedUDPPorts = [ 5353 ];
  services.openssh.openFirewall = false;
  networking.firewall.extraCommands = ''
    iptables -A nixos-fw -p tcp -s 192.168.15.0/24 --dport 22 -j ACCEPT
    ip6tables -A nixos-fw -p tcp -s fd00::/64 --dport 22 -j ACCEPT
  '';
}
