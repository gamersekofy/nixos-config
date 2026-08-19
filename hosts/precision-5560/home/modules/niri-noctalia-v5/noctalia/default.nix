{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
    ./themes.nix
    ./wallpaper-picker.nix
  ];

  home.packages = [
    pkgs.gradia
  ];

  programs.noctalia = {
    enable = true;
  };
}
