{pkgs, ...}: {
  home.packages = with pkgs; [
    kdePackages.kget

    keepassxc
    yubioath-flutter

    pciutils
    glxinfo
    clinfo
    wayland-utils
    aha
    fwupd
    glaxnimate
    ddcutil

    galaxy-buds-client

    fastfetch

    lmstudio

      ];
}
