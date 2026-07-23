{ config, pkgs, ... }:

{
  # Example for running a reverse proxy

  security.acme = {
    acceptTerms = true;
    defaults.email = "dont_forget_to_set_your_acme_email_here";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    appendHttpConfig = ''
      limit_req_zone $binary_remote_addr zone=test1_zone:10m rate=20r/s;
      limit_req_zone $binary_remote_addr zone=test2_zone:10m rate=20r/s;
    '';

    virtualHosts."test1.mydomain.org" = {
      forceSSL = true;
      enableACME = true;
      # HTTP & HTPPS
      locations."/" = {
        proxyPass = "http://127.0.0.1:7777";
        extraConfig = "limit_req zone=test1_zone burst=40 nodelay;";
      };
      # Websocket
      locations."/ws" = {
        proxyPass = "http://127.0.0.1:7777";
        proxyWebsockets = true;
        extraConfig = "limit_req zone=test1_zone burst=40 nodelay;";
      };
    };

    virtualHosts."test2.mydomain.org" = {
      forceSSL = true;
      enableACME = true;
      # HTTP & HTPPS
      locations."/" = {
        proxyPass = "http://127.0.0.1:7778";
        extraConfig = "limit_req zone=test2_zone burst=40 nodelay;";
      };
    };
  };
}
