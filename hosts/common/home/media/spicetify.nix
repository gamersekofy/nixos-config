{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];
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
