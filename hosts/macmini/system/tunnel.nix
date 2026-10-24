{config, ...}: {
  # Cloudflare Tunnel: no inbound ports, no certificates to renew.
  # cloudflared dials out to Cloudflare and proxies each hostname to loopback.
  services.cloudflared = {
    enable = true;
    tunnels.macmini = {
      credentialsFile = config.age.secrets.cloudflared-credentials.path;
      default = "http_status:404";
      ingress = {
        "casa.uzair.page".service = "http://127.0.0.1:8123";
        "docs.uzair.page".service = "http://127.0.0.1:28981";
        "git.uzair.page".service = "http://127.0.0.1:3000";
        "syncthing.uzair.page".service = "http://127.0.0.1:8384";
      };
    };
  };
}
