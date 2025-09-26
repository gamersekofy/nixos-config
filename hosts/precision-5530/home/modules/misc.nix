{pkgs, ...}: {
  home.packages = with pkgs; [
    keepassxc
    yubioath-flutter
    pciutils
    glxinfo
    clinfo
    wayland-utils
    aha
    ddcutil
    galaxy-buds-client
    fastfetch
    lmstudio

    openarena
  ];
}
