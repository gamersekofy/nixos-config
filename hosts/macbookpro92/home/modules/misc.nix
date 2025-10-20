{pkgs, ...}: {
  home.packages = with pkgs; [
    keepassxc
    yubioath-flutter
    fastfetch
  ];
}
