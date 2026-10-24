{
  virtualisation.oci-containers.containers.minecraft = {
    image = "itzg/minecraft-server:java21";
    ports = ["25565:25565"];
    volumes = [
      "/srv/minecraft/data:/data"
      "/srv/minecraft/mods:/mods"
      "/srv/minecraft/plugins:/plugins"
      "/srv/minecraft/config:/config"
    ];
    environment = {
      EULA = "TRUE";
      TZ = "America/Los_Angeles";
      INIT_MEMORY = "1G";
      MAX_MEMORY = "8G";
      ENABLE_AUTOPAUSE = "TRUE";
      AUTOPAUSE_TIMEOUT_INIT = "120";
      AUTOPAUSE_TIMEOUT_EST = "40";
    };
  };

  systemd.tmpfiles.rules = ["d /srv/minecraft 0755 root root -"];
}
