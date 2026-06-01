{ config, pkgs, ... }:
{
  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        MulticastDNS = "resolve";
      };
    };
  };

  networking.networkmanager = {
    enable = true;
    connectionConfig = {
      "connection.mdns" = 2;
    };
  };
}