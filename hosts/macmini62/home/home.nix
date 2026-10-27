{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./openclaw.nix
    ./misc.nix

    ../../common/home/dev/fish.nix
    ../../common/home/dev/starship.nix
    ../../common/home/dev/eza.nix
    ../../common/home/dev/atuin.nix
    ../../common/home/dev/yazi.nix
    ../../common/home/dev/bat.nix
    ../../common/home/dev/direnv.nix
    ../../common/home/dev/nix-index.nix
    ../../common/home/dev/helix.nix
    ../../common/home/dev/git.nix
  ];

  home.username = "uzair";
  home.homeDirectory = "/home/uzair";
  home.stateVersion = "26.11";

  programs.home-manager.enable = true;

  # programs.git = {
  #   enable = true;
  #   settings.user.name = "Uzair Mohammed";
  #   settings.user.email = "uzair.hamed@gmail.com";
  #   settings.init.defaultBranch = "main";
  # };

  # The shared fish module signs commits; this host has no YubiKey, so don't.
  programs.fish.shellAbbrs.gc = lib.mkForce "git commit -m";
}
