{pkgs, ...}: {
  home.sessionVariables = {
    NIXOS_CONFIG = "/home/uzair/Projects/nixos-config";
    COLORTERM = "truecolor";
  };

  home.packages = with pkgs; [
    wget
    unzip
    alejandra
    nixd
    aha

    gogcli
    ripgrep
    jq
    ffmpeg
    poppler-utils
    btop
    tmux

    gh

    # Headless browser for OpenClaw's Playwright automation. nixpkgs chromium
    # is a real, patched binary - no snap, no FHS - so it is launched straight
    # over CDP. Fonts live in hosts/common/system/fonts.nix: rendering is a
    # system concern, not a per-user package.
    chromium
  ];
}
