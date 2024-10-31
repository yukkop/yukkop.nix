# WIP
{ email, host }: { config, pkgs, ... }:
{
  services.postfix = {
    enable = true;
    relayDomains = ["hash:/var/lib/mailman/data/postfix_domains"];
    sslCert = config.security.acme.certs.${host}.directory + "/full.pem";
    sslKey = config.security.acme.certs.${host}.directory + "/key.pem";
    config = {
      transport_maps = ["hash:/var/lib/mailman/data/postfix_lmtp"];
      local_recipient_maps = ["hash:/var/lib/mailman/data/postfix_lmtp"];
    };
  };

  security.acme.email = email;
  security.acme.acceptTerms = true;

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  networking.firewall.allowedTCPPorts = [ 25 80 443 ];
}
