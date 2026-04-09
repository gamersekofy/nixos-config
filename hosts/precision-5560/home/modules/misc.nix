{pkgs, ...}: {
  home.packages = with pkgs; [
    keepassxc
    yubioath-flutter
    galaxy-buds-client
    fastfetch
    lmstudio
  ];
}
