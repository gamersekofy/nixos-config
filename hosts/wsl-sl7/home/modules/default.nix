{
  imports = [
    # Core CLI/dev modules (great for WSL)
    ../../../common/home/dev/fish.nix
    ../../../common/home/dev/eza.nix
    ../../../common/home/dev/starship.nix
    ../../../common/home/dev/direnv.nix
    ../../../common/home/dev/yazi.nix
    ../../../common/home/dev/bat.nix
    ../../../common/home/dev/nix-index.nix
    ../../../common/home/dev/helix.nix
    ../../../common/home/dev/git.nix

    ./misc.nix
    ./zed.nix
  ];
}
