{pkgs, ...}: {
  imports = [
    ../../../common/home/social/nixcord.nix
  ];
  home.packages = with pkgs; [
    zoom-us
    thunderbird
    element-desktop
    telegram-desktop

    teams-for-linux
  ];
}
