{pkgs, ...}: {
  imports = [
    ../../../common/home/social/nixcord.nix
  ];
  home.packages = with pkgs; [
    zoom-us
    thunderbird
    telegram-desktop
    slack
  ];
}
