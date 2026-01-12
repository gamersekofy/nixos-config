{lib, ...}: {
  imports = [
    ../../../../common/home/dev/helix.nix
  ];

  programs.helix.settings.theme = lib.mkForce "base16_terminal";
}
