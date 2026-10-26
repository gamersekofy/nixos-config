{config, ...}: {
  # Paperless + the scanner share + firewall, together on purpose.
  services.paperless = {
    enable = true;
    address = "127.0.0.1";
    port = 28981;
    dataDir = "/var/lib/paperless/data";
    mediaDir = "/var/lib/paperless/media";
    consumptionDir = "/var/lib/paperless/consume";
    consumptionDirIsPublic = true;
    passwordFile = config.age.secrets.paperless-admin-password.path;

    # The legacy instance used PostgreSQL 13 and Tika/Gotenberg. Without
    # createLocally the module defaults to SQLite, and the documented psql
    # restore would target a database that does not exist.
    database.createLocally = true;
    configureTika = true;

    settings = {
      PAPERLESS_TIME_ZONE = "America/Los_Angeles";
      PAPERLESS_OCR_LANGUAGE = "eng";
      PAPERLESS_FILENAME_FORMAT = "{created_year}/{correspondent}/{title}";
      PAPERLESS_URL = "https://docs.uzair.page";
      PAPERLESS_TRUSTED_PROXIES = "127.0.0.1";
      PAPERLESS_CSRF_TRUSTED_ORIGINS = "https://docs.uzair.page";
    };
  };

  # Printer scans land in consume/. Guest-writable, forced to paperless.
  services.samba = {
    enable = true;
    openFirewall = false;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "macmini62";
        "map to guest" = "Bad User";
        "server min protocol" = "SMB2";
      };
      scans = {
        path = "/var/lib/paperless/consume";
        browseable = "yes";
        writable = "yes";
        "guest ok" = "yes";
        "force user" = "paperless";
        "create mask" = "0664";
        "directory mask" = "0775";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [139 445];
}
