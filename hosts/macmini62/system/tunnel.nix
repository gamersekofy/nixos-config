{config, ...}: {
  # Cloudflare Tunnel: no inbound ports, no certificates to renew.
  # cloudflared dials out to Cloudflare and proxies each hostname to loopback.
  services.cloudflared = {
    enable = true;
    tunnels.macmini62 = {
      credentialsFile = config.age.secrets.cloudflared-credentials.path;
      default = "http_status:404";
      # Privacy first: Cloudflare terminates TLS at the edge, so only Gitea
      # goes public. Home Assistant and Paperless are served on the tailnet by
      # tailscale serve instead. Syncthing is not public either.
      ingress = {
        # Gitea is on 3001; 3000 belongs to Paperless's Gotenberg.
        "git.uzair.page".service = "http://127.0.0.1:3001";
      };
    };
  };
}
