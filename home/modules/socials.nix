{pkgs, ...}: {
  home.packages = with pkgs; [
    zoom-us
    vesktop
    thunderbird
  ];
}
