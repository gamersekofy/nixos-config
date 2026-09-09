{pkgs, ...}: {
  programs.libreoffice = {
    enable = true;
    package = pkgs.libreoffice-qt-stable;
  };
}
