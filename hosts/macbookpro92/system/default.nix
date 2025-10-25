{
  imports = [
    ./bootloader.nix
    ./wireless.nix
    ./hardware-configuration.nix
    ./miscNixStuff.nix
    ./graphics.nix

    ../../common/system/powerManagement.nix
    ../../common/system/tzLocale.nix
    ../../common/system/users.nix
    ../../common/system/nerdFonts.nix
    ../../common/system/nixos-cli.nix
    ../../common/system/printing.nix
    ../../common/system/yubikey.nix
    ../../common/system/pipewire.nix
    ../../common/system/sddm.nix
    ../../common/system/mbpfan.nix

    ../../common/system/wayland.nix
    ../../common/system/kdePlasma.nix
    ../../common/system/gpu-screen-recorder.nix
  ];
}
