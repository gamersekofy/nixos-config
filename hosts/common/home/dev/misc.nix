{pkgs, ...}: {
  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    NIXOS_CONFIG = "/home/uzair/Documents/nixos-config";
    #XCURSOR_THEME = "Furina-v2";
    #XCURSOR_SIZE = 32;
  };

  home.packages = with pkgs; [
    wget
    unzip
    alejandra
    nixd
    fasd

    pciutils
    glxinfo
    clinfo
    wayland-utils
    aha
    ddcutil
  ];
}
