{
  # Faithful port of hosts/macmini62/legacy/minecraft-server/docker-compose.yaml.
  # The container data is restored to /srv/minecraft, so the image must still
  # be told it is Fabric and which version to run.
  virtualisation.oci-containers.containers.minecraft = {
    # Fully qualified: Podman has no unqualified-search registry configured,
    # so the bare Docker Hub short name fails with "short-name did not resolve".
    image = "docker.io/itzg/minecraft-server:java21";
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
      TYPE = "FABRIC";
      VERSION = "1.21.11";
      OVERRIDE_SERVER_PROPERTIES = "TRUE";
      MAX_TICK_TIME = "-1";
      ENFORCE_SECURE_PROFILE = "FALSE";
      ONLINE_MODE = "TRUE";
      INIT_MEMORY = "1G";
      MAX_MEMORY = "8G";
      ENABLE_AUTOPAUSE = "TRUE";
      AUTOPAUSE_TIMEOUT_INIT = "120";
      AUTOPAUSE_TIMEOUT_EST = "40";

      RESOURCE_PACK = "https://cdn.modrinth.com/data/uvpymuxq/versions/XWtayRKd/Better-Leaves-9.5.zip";

      MODS = ''
        https://cdn.modrinth.com/data/P7dR8mSH/versions/i5tSkVBH/fabric-api-0.141.3%2B1.21.11.jar
        https://cdn.modrinth.com/data/Fb4jn8m6/versions/Hnj3s9Ez/FallingTree-1.21.11-1.21.11.3.jar
        https://cdn.modrinth.com/data/kfqD1JRw/versions/dn5ujpT7/VisualWorkbench-v21.11.1-mc1.21.11-Fabric.jar
        https://cdn.modrinth.com/data/QAGBst4M/versions/O1SlsQzW/PuzzlesLib-v21.11.11-mc1.21.11-Fabric.jar
        https://cdn.modrinth.com/data/ohNO6lps/versions/uXrWPsCu/ForgeConfigAPIPort-v21.11.1-mc1.21.11-Fabric.jar
        https://cdn.modrinth.com/data/qwMPYms7/versions/2hOuJZ7T/cherry-monastery-5.13.jar
        https://cdn.modrinth.com/data/dtWC90iB/versions/xhmciaUD/mcw-furniture-3.4.2-mc1.21.11fabric.jar
        https://cdn.modrinth.com/data/GmwLse2I/versions/KvcFYpyP/mcw-fences-1.2.1-mc1.21.11fabric.jar
        https://cdn.modrinth.com/data/C7I0BCni/versions/uriWt4r9/mcw-windows-2.4.2-mc1.21.11fabric.jar
        https://cdn.modrinth.com/data/GURcjz8O/versions/VwHKtWix/mcw-bridges-3.1.2-mc1.21.11fabric.jar
        https://cdn.modrinth.com/data/kNxa8z3e/versions/G56MgNgk/mcw-doors-1.1.5-mc1.21.11fabric.jar
        https://cdn.modrinth.com/data/iP3wH1ha/versions/HePuVuYI/mcw-stairs-1.0.2-mc1.21.11fabric.jar
        https://cdn.modrinth.com/data/B8jaH3P1/versions/KQqPCHJC/mcw-roofs-2.3.2-mc1.21.11fabric.jar
        https://cdn.modrinth.com/data/VRLhWB91/versions/RgddKk8C/mcw-paths-1.1.1-mc1.21.11fabric.jar
        https://cdn.modrinth.com/data/w4an97C2/versions/DXV1gXS5/mcw-lights-1.1.5-mc1.21.11fabric.jar
        https://cdn.modrinth.com/data/n2fvCDlM/versions/smpXiL59/mcw-trapdoors-1.1.5-mc1.21.11fabric.jar
        https://cdn.modrinth.com/data/rlloIFEV/versions/jDSDEMgY/travelersbackpack-fabric-1.21.11-10.11.5.jar
        https://cdn.modrinth.com/data/SaCpeal4/versions/OPABkLvU/comforts-fabric-14.0.2%2B1.21.11.jar
        https://cdn.modrinth.com/data/OhduvhIc/versions/SMDUhqTN/veinminer-fabric-2.5.2.jar
        https://cdn.modrinth.com/data/nvQzSEkH/versions/sGI08gfW/Jade-1.21.11-Fabric-21.1.4.jar
        https://cdn.modrinth.com/data/HXF82T3G/versions/wfaWqpie/BiomesOPlenty-fabric-1.21.11-21.11.0.31.jar
        https://cdn.modrinth.com/data/s3dmwKy5/versions/CO7NeLTt/GlitchCore-fabric-1.21.11-21.11.0.4.jar
        https://cdn.modrinth.com/data/kkmrDlKT/versions/chxo508B/TerraBlender-fabric-1.21.11-21.11.0.0.jar
        https://cdn.modrinth.com/data/9s6osm5g/versions/xuX40TN5/cloth-config-21.11.153-fabric.jar
        https://cdn.modrinth.com/data/Ha28R6CL/versions/ViT4gucI/fabric-language-kotlin-1.13.9%2Bkotlin.2.3.10.jar
        https://cdn.modrinth.com/data/aTaCgKLW/versions/tgYliGAU/silk-all-1.11.5.jar
        https://cdn.modrinth.com/data/lhGA9TYQ/versions/uNdfrcQ8/architectury-19.0.1-fabric.jar
        https://cdn.modrinth.com/data/XkisZUfp/versions/lQ0CiYEU/BuildingWands-fabric-MC1.21.11-3.0.2.jar

        https://cdn.modrinth.com/data/uXXizFIs/versions/Ii0gP3D8/ferritecore-8.2.0-fabric.jar?mr_download_reason=standalone&mr_game_version=1.21.11&mr_loader=fabric
        https://cdn.modrinth.com/data/fQEb0iXm/versions/O9LmWYR7/krypton-0.2.10.jar?mr_download_reason=standalone&mr_game_version=1.21.11&mr_loader=fabric
        https://cdn.modrinth.com/data/gvQqBUqZ/versions/Ow7wA0kG/lithium-fabric-0.21.4%2Bmc1.21.11.jar?mr_download_reason=standalone&mr_game_version=1.21.11&mr_loader=fabric
      '';

      ICON = "https://i.imgur.com/xRIDs7x.png";
      MAX_PLAYERS = "3";
      SERVER_NAME = "Uzy, Tof, and Kim's Abode. Gtfo if you're not us.";

      EXISTING_WHITELIST_FILE = "SYNCHRONIZE";
      WHITELIST = ''
        0xAya
        cassidyrose1
        kaybruhh
      '';

      EXISTING_OPS_FILE = "SYNCHRONIZE";
      OPS = ''
        0xAya
        cassidyrose1
        kaybruhh
      '';

      ENABLE_COMMAND_BLOCK = "TRUE";
      ALLOW_CHEATS = "TRUE";
      PVP = "FALSE";
    };
  };

  systemd.tmpfiles.rules = ["d /srv/minecraft 0755 root root -"];
}
