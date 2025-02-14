{pkgs, ...}: {
  home.packages = with pkgs; [
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
