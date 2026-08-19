{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      spicyLyrics
    ];

    theme = {
      name = "Comfy";
      src = spicePkgs.themes.comfy.src; # Uses the package's fetched GitHub source path

      overwriteAssets = true;
      injectCss = true;
      injectThemeJs = true;
      replaceColors = true;
      homeConfig = true;
    };

    colorScheme = "Comfy";
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
    ];
  };
}
