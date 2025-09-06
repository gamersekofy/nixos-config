{
  pkgs,
  inputs,
  ...
}: {

  imports = [
    ../../../common/home/media/obs.nix
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

  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      beautifulLyrics
    ];
    theme = spicePkgs.themes.text;
    colorScheme = "CatppuccinMocha";
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
    ];
  };
}
