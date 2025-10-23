{
  pkgs,
  ...
}: {
  imports = [
    ../../../common/home/media/obs.nix
    ../../../common/home/media/spicetify.nix
  ];

  home.packages = with pkgs; [
    haruna
    gpu-screen-recorder-gtk
    nicotine-plus
    # clementine
    inkscape
  ];
}
