{pkgs, ...}: {
  imports = [
    ../../../common/home/misc/firefox.nix
  ];
  home.packages = with pkgs; [
    microsoft-edge
  ];
}
