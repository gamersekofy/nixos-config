{config, ...}: {
  services.syncthing = {
    enable = true;
    user = "uzair";
    dataDir = "/home/uzair/Documents/syncthing";
    configDir = "/home/uzair/Documents/syncthing/config";
    guiAddress = "127.0.0.1:8384";

    # Open only the sync/discovery ports (22000/21027), never the GUI. Without
    # this, transfers between LAN devices are silently blocked by the firewall.
    openDefaultPorts = true;

    # Both sides are declared here rather than clicked in the GUI: override
    # makes the flake authoritative, so a rebuild cannot forget a pairing.
    # Device IDs are public key fingerprints, not secrets - they are safe in
    # the store and useless to anyone who has not been accepted as a device.
    overrideDevices = true;
    overrideFolders = true;

    settings = {
      # The macmini62 GUI is loopback-only and is no longer published through
      # the Cloudflare Tunnel. Use an SSH tunnel or Tailscale to reach it.
      gui.user = "uzair";

      devices = {
        "precision-5560" = {
          id = "CMFRRBL-GTRFUCO-QCZOFRU-AF74VND-RK7YPOF-OMT5ZC2-QHG2DEL-GZ36GAL";
        };
      };

      folders = {
        # A backup copy of the laptop's library, so receive-only: the Mac mini
        # never pushes a change back into the source.
        "Music" = {
          path = "/home/uzair/Music";
          type = "receiveonly";
          devices = ["precision-5560"];
        };
        "Secrets" = {
          path = "/home/uzair/Secrets";
          devices = ["precision-5560"];
        };
        "Resumable" = {
          path = "/home/uzair/Pictures/.snap";
          devices = ["precision-5560"];
        };
      };
    };

    guiPasswordFile = config.age.secrets.syncthing-password.path;
  };
}
