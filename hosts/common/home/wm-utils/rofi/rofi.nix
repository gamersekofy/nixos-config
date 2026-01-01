{pkgs, ...}: {
  programs.rofi = {
    enable = true;

    theme = "${./catppuccin-mocha.rasi}";
  };

  home.packages = [
    pkgs.rofimoji
  ];
}
