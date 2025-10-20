{
  imports = [
    ./bootloader.nix
    ./wireless.nix
    ./hardware-configuration.nix
    ./miscNixStuff.nix

    ../../common/system/powerManagement.nix
    ../../common/system/tzLocale.nix
    ../../common/system/users.nix
    ../../common/system/nerdFonts.nix
    ../../common/system/nixos-cli.nix
    ../../common/system/printing.nix
    ../../common/system/yubikey.nix
    ../../common/system/pipewire.nix
    ../../common/system/sddm.nix

    ../../common/system/wayland.nix
    ../../common/system/kdePlasma.nix
  ];
}
