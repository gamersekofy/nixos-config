{pkgs, ...}: {
  imports = [
    ../../../common/home/media/minecraft.nix
  ];
  home.packages = with pkgs; [
    heroic
    mangohud
    osu-lazer-bin

    openarena
  ];
}
