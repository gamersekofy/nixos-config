{pkgs, ...}: {
  home.packages = with pkgs; [
    kdePackages.arianna
    calibre
    obsidian
    libreoffice-qt6-fresh
  ];
}
