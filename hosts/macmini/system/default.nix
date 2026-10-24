{
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
