{
  virtualisation.oci-containers.containers.homeassistant = {
    image = "ghcr.io/home-assistant/home-assistant:stable";
    volumes = [
      "/var/lib/hass:/config"
      "/run/dbus:/run/dbus:ro"
      "/etc/localtime:/etc/localtime:ro"
    ];
    environment.TZ = "America/Los_Angeles";
    extraOptions = ["--network=host" "--privileged"];
  };

  systemd.tmpfiles.rules = ["d /var/lib/hass 0755 root root -"];
}
