{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    nicotine-plus
    gimp
    kdePackages.kdenlive
    digikam
    haruna
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      obs-studio-plugins.obs-pipewire-audio-capture
      obs-studio-plugins.obs-backgroundremoval
      obs-studio-plugins.input-overlay
      obs-studio-plugins.obs-vaapi
    ];
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
