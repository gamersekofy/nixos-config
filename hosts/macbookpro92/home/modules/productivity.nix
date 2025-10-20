{pkgs, ...}: {
  imports = [
    ../../../common/home/misc/sioyek.nix
  ];
  home.packages = with pkgs; [
    qalculate-qt
    libreoffice-qt6-fresh
  ];
}
