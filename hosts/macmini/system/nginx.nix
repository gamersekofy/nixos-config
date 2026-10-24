{
  # Vhosts only. TLS is deferred: terminate at a Cloudflare Tunnel
  # (recommended) or add security.acme with DNS-01, below.
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    clientMaxBodySize = "2g";

    virtualHosts = {
      "casa.uzair.page".locations."/" = {
        proxyPass = "http://127.0.0.1:8123";
        proxyWebsockets = true;
      };
      "docs.uzair.page".locations."/" = {
        proxyPass = "http://127.0.0.1:28981";
        proxyWebsockets = true;
      };
      "git.uzair.page".locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
      };
      "syncthing.uzair.page".locations."/" = {
        proxyPass = "http://127.0.0.1:8384";
        proxyWebsockets = true;
      };
    };
  };

  # Option A: Cloudflare Tunnel
  # services.cloudflared = {
  #   enable = true;
  #   tunnels.macmini = {
  #     credentialsFile = "/run/secrets/cloudflared-tunnel.json";
  #     default = "http_status:404";
  #     ingress = {
  #       "casa.uzair.page".service = "http://127.0.0.1:8123";
  #       "docs.uzair.page".service = "http://127.0.0.1:28981";
  #       "git.uzair.page".service = "http://127.0.0.1:3000";
  #       "syncthing.uzair.page".service = "http://127.0.0.1:8384";
  #     };
  #   };
  # };

  # Option B: origin certs with DNS-01
  # security.acme.defaults = {
  #   email = "uzair.hamed@gmail.com";
  #   dnsProvider = "cloudflare";
  #   credentialsFile = "/run/secrets/cloudflare.ini";
  # };
}
