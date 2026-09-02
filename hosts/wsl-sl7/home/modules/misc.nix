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
    fasd
    aha
  ];
}
