{
  # OpenClaw runs as a systemd user service. Without lingering, it does not
  # start until uzair logs in, which never happens on a headless server.
  users.users.uzair.linger = true;

  imports = [
    ./bootloader.nix
    ./hardware-configuration.nix
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
