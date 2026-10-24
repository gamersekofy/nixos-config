{
  services.restic.backups.macmini = {
    repository = "sftp:uzair@precision-5560:/home/uzair/backups/macmini";
    passwordFile = "/run/secrets/restic-password";
    initialize = true;
    paths = [
      "/var/lib/gitea"
      "/var/lib/paperless"
      "/srv/minecraft"
      "/var/lib/hass"
      "/home/uzair/.openclaw"
      "/etc/nixos"
    ];
    exclude = [
      "/var/lib/docker"
      "/home/uzair/.openclaw/cache"
      "/home/uzair/.openclaw/tmp"
      "/home/uzair/.openclaw/browser"
      "/home/uzair/.openclaw/npm"
      "*.tmp"
    ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };
  };
}
