{
  config,
  pkgs,
  ...
}: {
  # Dump both PostgreSQL databases (gitea and paperless) before restic runs.
  # Restic intentionally does not back up /var/lib/postgresql directly: a live
  # data directory is not crash-consistent.
  services.postgresqlBackup = {
    enable = true;
    startAt = "*-*-* 00:30:00";
  };

  # restic runs as root over SFTP; root needs to trust the 5560 host key.
  programs.ssh.knownHosts.precision-5560 = {
    hostNames = ["precision-5560" "100.117.32.104" "192.168.86.142"];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtqLcR0SjyMeXmbo+pbCTJKTM0GmTc+Q/fYmITAwIgn root@precision-5560";
  };

  systemd.tmpfiles.rules = ["d /var/backup/openclaw 0700 root root -"];

  services.restic.backups.macmini62 = {
    repository = "sftp:uzair@100.117.32.104:/home/uzair/backups/macmini62";
    passwordFile = config.age.secrets.restic-password.path;
    initialize = true;
    paths = [
      "/var/lib/gitea"
      "/var/lib/paperless"
      "/var/backup/postgresql"
      "/var/backup/openclaw"
      "/srv/minecraft"
      "/var/lib/hass"
      "/home/uzair/.openclaw"
      "/home/uzair/Projects/nixos-config"
    ];

    # OpenClaw's SQLite database is copied with sqlite3 .backup first; the live
    # file is excluded so restic never captures a torn database.
    backupPrepareCommand = ''
      mkdir -p /var/backup/openclaw
      if [ -f /home/uzair/.openclaw/state/openclaw.sqlite ]; then
        ${pkgs.sqlite}/bin/sqlite3 /home/uzair/.openclaw/state/openclaw.sqlite \
          ".backup /var/backup/openclaw/openclaw.sqlite"
      fi
    '';
    backupCleanupCommand = "rm -rf /var/backup/openclaw";

    exclude = [
      "/var/lib/docker"
      "/home/uzair/.openclaw/state/openclaw.sqlite"
      "/home/uzair/.openclaw/state/openclaw.sqlite-wal"
      "/home/uzair/.openclaw/state/openclaw.sqlite-shm"
      "/home/uzair/.openclaw/cache"
      "/home/uzair/.openclaw/tmp"
      "/home/uzair/.openclaw/browser"
      "/home/uzair/.openclaw/npm"
      "*.tmp"
    ];

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 6"
    ];
    checkOpts = ["--read-data-subset=1/20"];

    timerConfig = {
      OnCalendar = "*-*-* 02:00:00";
      Persistent = true;
      RandomizedDelaySec = "15m";
    };
  };
}
