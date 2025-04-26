{pkgs, ...}: {
  imports = [
    ./neovim.nix
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    NIXOS_CONFIG = "/home/uzair/Documents/nixos-config";
    #XCURSOR_THEME = "Furina-v2";
    #XCURSOR_SIZE = 32;
  };

  programs.zed-editor.enable = true;

  home.packages = with pkgs; [
    # GUI code editors
    kdePackages.kate
    vscode.fhs

    # Utilities
    wget
    unzip

    # IDE
    jetbrains.idea-ultimate
    jetbrains.rider

    # nix language server
    nixd

    # nix formatter
    alejandra

    # something for fish lol
    fasd
  ];
}
