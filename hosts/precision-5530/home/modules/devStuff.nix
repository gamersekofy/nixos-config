{pkgs, ...}: {
  imports = [
    # ./neovim.nix
    ../../../common/home/editors/helix.nix
  ];
  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    NIXOS_CONFIG = "/home/uzair/Documents/nixos-config";
    #XCURSOR_THEME = "Furina-v2";
    #XCURSOR_SIZE = 32;
  };

  home.packages = with pkgs; [
    # GUI code editors
    kdePackages.kate
    vscode.fhs
    jetbrains.idea-ultimate
    # zed-editor

    # Utilities
    wget
    unzip

    # nix language server
    # nixd

    # nix formatter
    alejandra

    # something for fish lol
    fasd
  ];
}
