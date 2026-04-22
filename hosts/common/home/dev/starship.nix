{lib, ...}: {
  # Enable the starship prompt and use the default config
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    presets = [];
    settings = import ./starship-presets/jetpack.nix {inherit lib;};
  };
}
