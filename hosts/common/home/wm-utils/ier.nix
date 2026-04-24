{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.ie-r.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
