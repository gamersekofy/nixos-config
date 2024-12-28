{pkgs, ...}: {
  imports = [
    ./neovim.nix
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "fish";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    NIXOS_CONFIG = "/home/uzair/Documents/nixos-config";
  };

  programs.helix = {
    enable = true;
  };

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
