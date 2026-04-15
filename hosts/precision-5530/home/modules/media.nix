{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../../common/home/media/obs.nix
    ../../../common/home/media/spicetify.nix
  ];

  home.packages = with pkgs; [
    gimp3
    kdePackages.kdenlive
    digikam
    haruna
    qtscrcpy
    nicotine-plus
    clementine
    kdePackages.kolourpaint
  ];

  programs.obs-studio = {
    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };
  };
}
