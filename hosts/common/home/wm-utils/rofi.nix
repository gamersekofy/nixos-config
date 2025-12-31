{pkgs, ...}: {
  programs.rofi = {
    enable = true;
  };

  home.packages = [
    pkgs.rofimoji
  ];
}
