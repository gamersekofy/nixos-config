{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./modules/default.nix
  ];

  home.username = "uzair";
  home.homeDirectory = "/home/uzair";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
