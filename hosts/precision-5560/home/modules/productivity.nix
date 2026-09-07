{pkgs, ...}: {
  imports = [
    ../../../common/home/productivity/sioyek.nix
    ../../../common/home/productivity/libreoffice.nix
    ../../../common/home/productivity/calibre.nix
    ../../../common/home/productivity/qalculate.nix
    ../../../common/home/productivity/obsidian.nix
  ];
  home.packages = with pkgs; [
    drawy
  ];
}
