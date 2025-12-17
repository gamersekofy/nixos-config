{pkgs, ...}: {
  imports = [
    ../../../common/home/misc/sioyek.nix
  ];
  home.packages = with pkgs; [
    qalculate-qt
    calibre
    obsidian
    libreoffice-qt6-fresh
  ];
}
