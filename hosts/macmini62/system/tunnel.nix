{config, ...}: {
  # Cloudflare Tunnel: no inbound ports, no certificates to renew.
  # cloudflared dials out to Cloudflare and proxies each hostname to loopback.
  services.cloudflared = {
    enable = true;
    tunnels.macmini62 = {
      credentialsFile = config.age.secrets.cloudflared-credentials.path;
      default = "http_status:404";
      ingress = {
        "casa.uzair.page".service = "http://127.0.0.1:8123";
        "docs.uzair.page".service = "http://127.0.0.1:28981";
        # Gitea is on 3001; 3000 belongs to Paperless's Gotenberg.
        "git.uzair.page".service = "http://127.0.0.1:3001";
        # Syncthing is intentionally not public. Reach it through Tailscale or
        # an SSH tunnel; its GUI also has password auth.
      };
    };
  };
}
