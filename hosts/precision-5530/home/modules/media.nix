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
    gpu-screen-recorder-gtk
    qtscrcpy
    nicotine-plus
  ];

  programs.obs-studio = {
    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };
  };
}
