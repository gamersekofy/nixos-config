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

    # The macmini62 GUI is loopback-only and is no longer published through the
    # Cloudflare Tunnel. Use an SSH tunnel or Tailscale to reach it.
    settings.gui.user = "uzair";
    guiPasswordFile = config.age.secrets.syncthing-password.path;
  };
}
