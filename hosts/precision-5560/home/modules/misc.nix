{pkgs, ...}: {
  imports = [
    ../../../common/home/misc/fastfetch.nix
    ../../../common/home/misc/keepassxc.nix
  ];

  home.packages = with pkgs; [
    yubioath-flutter
    galaxy-buds-client
    lmstudio
  ];
}
