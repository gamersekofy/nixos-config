{pkgs, ...}: {
  home.packages = with pkgs; [
    heroic
    mangohud
    osu-lazer-bin
    steam
    prismlauncher
  ];
}
