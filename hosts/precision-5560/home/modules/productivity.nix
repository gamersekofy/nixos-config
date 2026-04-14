{pkgs, ...}: {
  imports = [
    ../../../common/home/misc/sioyek.nix
  ];
  home.packages = with pkgs; [
    qalculate-gtk
    calibre
    obsidian
    libreoffice-qt6-fresh
  ];
}
