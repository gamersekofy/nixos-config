{pkgs, ...}: {
  imports = [
    ./neovim.nix
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "/etc/profiles/per-user/uzair/bin/fish";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    NIXOS_CONFIG = "/home/uzair/Documents/nixos-config";
    #XCURSOR_THEME = "Furina-v2";
    #XCURSOR_SIZE = 32;
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
    (jetbrains.plugins.addPlugins jetbrains.idea-ultimate ["github-copilot"])
    jetbrains.rider

    # nix language server
    nixd

    # nix formatter
    alejandra

    # something for fish lol
    fasd
  ];
}
