{pkgs, ...}: {
  home.packages = with pkgs; [
    kdePackages.arianna
    kdePackages.kalgebra
    calibre
    obsidian
    libreoffice-qt6-fresh
  ];
}
