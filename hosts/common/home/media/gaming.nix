{pkgs, ...}: {
  imports = [
    ./minecraft.nix
  ];
  home.packages = with pkgs; [
    heroic
    mangohud
    osu-lazer-bin

    openarena
  ];
}
