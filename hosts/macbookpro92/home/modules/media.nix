{pkgs, ...}: {
  imports = [
    ../../../common/home/media/obs.nix
    ../../../common/home/media/spicetify.nix
  ];

  home.packages = with pkgs; [
    haruna
    nicotine-plus
    inkscape
    kdePackages.kolourpaint
    makemkv
  ];
}
