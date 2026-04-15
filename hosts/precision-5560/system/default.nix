{
  imports = [
    ./bootloader.nix
    ./wireless.nix
    ./syncthing.nix
    ./media.nix
    ./hardware-configuration.nix
    ./miscNixStuff.nix
    ./lanzaboote.nix
    # ./sddm.nix
    ../../common/system/sddm.nix
    ./special-hardware.nix
    ./secondary-ssd.nix
    ./graphics.nix

    ../../common/system/powerManagement.nix
    ../../common/system/tzLocale.nix
    ../../common/system/users.nix
    ../../common/system/virt.nix
    ../../common/system/fonts.nix
    ../../common/system/nixos-cli.nix
    ../../common/system/printing.nix
    ../../common/system/yubikey.nix
    ../../common/system/steam.nix
    ../../common/system/thunderbolt.nix
    ../../common/system/pipewire.nix
    ../../common/system/gpu-screen-recorder.nix
    ../../common/system/wireshark.nix

    ../../common/system/wayland.nix
    # ../../common/system/kdePlasma.nix
    ../../common/system/niri.nix
    ../../common/system/noctalia.nix
  ];
}
