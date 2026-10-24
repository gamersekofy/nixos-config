{
  # Paperless + the scanner share + firewall, together on purpose.
  services.paperless = {
    enable = true;
    address = "127.0.0.1";
    port = 28981;
    dataDir = "/var/lib/paperless/data";
    mediaDir = "/var/lib/paperless/media";
    consumptionDir = "/var/lib/paperless/consume";
    consumptionDirIsPublic = true;
    passwordFile = "/run/secrets/paperless-admin-password";

    settings = {
      PAPERLESS_TIME_ZONE = "America/Los_Angeles";
      PAPERLESS_OCR_LANGUAGE = "eng";
      PAPERLESS_FILENAME_FORMAT = "{created_year}/{correspondent}/{title}";
      PAPERLESS_URL = "https://docs.uzair.page";
      PAPERLESS_TRUSTED_PROXIES = "127.0.0.1";
    };
  };

  # Printer scans land in consume/. Guest-writable, forced to paperless.
  services.samba = {
    enable = true;
    openFirewall = false;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "macmini";
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
