{
  imports = [
    ./bootloader.nix
    ./powerManagement.nix
    ./wireless.nix
    ./syncthing.nix
    ./media.nix
    ./suspendThenHibernate.nix
    ./hardware-configuration.nix
    ./tzLocale.nix
    ./users.nix
    ./virt.nix
    ./miscNixStuff.nix
    ./nerdFonts.nix
    ./nixos-cli.nix
    ./lanzaboote.nix
    ./printing.nix
    ./yubikey.nix
    ./steam.nix

    ./wayland.nix
    ./sddm.nix

    #./kdePlasma.nix
    #./hyprland.nix
    #./niri.nix
  ];
}
