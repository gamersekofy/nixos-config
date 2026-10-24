{
  # 8 GB swap on the SSD. With 16 GB RAM this is a safety net, not a working
  # set. Declared here so regenerating hardware-configuration.nix cannot lose
  # it; the generated empty list merges harmlessly.
  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  # OpenClaw runs as a systemd user service. Without lingering, it does not
  # start until uzair logs in, which never happens on a headless server.
  users.users.uzair.linger = true;

  imports = [
    # ./bootloader.nix             # Uzair writes this one
    # ./hardware-configuration.nix # from nixos-generate-config
    ./nix-settings.nix
    ./networking.nix
    ./ssh.nix
    ./docker.nix
    ./tunnel.nix
    ./secrets.nix
    ./syncthing.nix
    ./paperless.nix
    ./gitea.nix
    ./hass.nix
    ./minecraft.nix
    ./backup.nix

    ../../common/system/tzLocale.nix
    ../../common/system/users.nix
    ../../common/system/tailscale.nix
  ];
}
