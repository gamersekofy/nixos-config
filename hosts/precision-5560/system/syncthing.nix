{pkgs, ...}: {
  # Enable and set up Syncthing
  services.syncthing = {
    enable = true;
    user = "uzair";
    dataDir = "/home/uzair/Documents/syncthing";
    configDir = "/home/uzair/Documents/syncthing/config";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      gui = {
        user = "uzair";
        # bcrypt hash of the old GUI password; no plaintext in the Nix store.
        # Change it with: mkpasswd -m bcrypt '<new password>'
        password = "$2b$12$zXaVSGsA20SjWkgqxRvcnO8uQlIyIzOL76Ok/oMDgtkSCZkWTefGu";
      };
      devices = {
        "uzairPhone" = {id = "NA6LMLH-LWJ3L4L-PMVSSCH-BFUHRUU-B7TXBGU-746NUWZ-P5F5DFK-QJQM2QD";};
        # The reinstall generated a new identity on the macmini62. Taken from
        # /home/uzair/Documents/syncthing/config/config.xml on that host.
        "macMiniServer" = {id = "FZ42UBM-WWE33JP-PDT63WT-UQMP6LY-27BO2IM-IXSXBJG-FMYXQ5W-3S4SMAP";};
      };
      folders = {
        "Music" = {
          path = "/home/uzair/Music";
          # The Mac mini holds the backup copy, so this side only sends.
          type = "sendonly";
          devices = ["macMiniServer"];
        };
        "Secrets" = {
          path = "/home/uzair/Secrets";
          devices = ["macMiniServer" "uzairPhone"];
        };
        "Resumable" = {
          path = "/home/uzair/Pictures/.snap";
          devices = ["macMiniServer" "uzairPhone"];
        };
      };
    };
  };
}
