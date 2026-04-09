{
  pkgs,
  inputs,
  ...
}: let
  tux = inputs.tuxmanager.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  environment.systemPackages = [
    tux

    (pkgs.makeDesktopItem {
      name = "tux-manager";
      desktopName = "Tux Manager";
      exec = "${tux}/bin/tux-manager";
      icon = "xfce4-cpugraph-plugin";
      terminal = false;
      categories = ["Utility"];
    })
  ];
}
