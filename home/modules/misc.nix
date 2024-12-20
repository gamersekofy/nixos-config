{pkgs, ...}: {
  home.packages = with pkgs; [
    kdePackages.kdenlive
    kdePackages.kget
    kdePackages.kalgebra

    keepassxc
    
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

    yubioath-flutter
  ];
}
