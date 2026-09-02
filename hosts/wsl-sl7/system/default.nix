{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../common/system/tzLocale.nix
    ../../common/system/users.nix
    ../../common/system/nixos-cli.nix
    ../../common/system/yubikey.nix

    ./wireless.nix
    ./misc-packages.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "uzair";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Keep this exactly from your current setup
  system.stateVersion = "26.05";
}
