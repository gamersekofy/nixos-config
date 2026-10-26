{
  virtualisation.oci-containers.containers.homeassistant = {
    image = "ghcr.io/home-assistant/home-assistant:stable";
    volumes = [
      "/var/lib/hass:/config"
      "/run/dbus:/run/dbus:ro"
      "/etc/localtime:/etc/localtime:ro"
    ];
    # No USB radio in this machine. Docker refuses to start a container whose
    # --device path is missing, so add this only when a stick is present:
    #   devices = ["/dev/ttyUSB0"];
    environment.TZ = "America/Los_Angeles";
    extraOptions = ["--network=host" "--privileged"];
  };

  # Matter controller from the legacy compose file. Home Assistant talks to it
  # on localhost:5580 (host networking).
  virtualisation.oci-containers.containers.matter-server = {
    image = "ghcr.io/home-assistant-libs/python-matter-server:stable";
    volumes = [
      "/var/lib/matter-server:/data"
      "/run/dbus:/run/dbus:ro"
    ];
    extraOptions = ["--network=host" "--security-opt=apparmor=unconfined"];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/hass 0755 root root -"
    "d /var/lib/matter-server 0755 root root -"
  ];
}
