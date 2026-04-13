{
  pkgs,
  inputs,
  ...
}: let
  tux = inputs.tuxmanager.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  environment.systemPackages = [
    tux
  ];
}
