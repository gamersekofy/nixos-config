{pkgs, ...}: {
  home.packages = with pkgs; [
    brightnessctl
    wl-clipboard
    playerctl

    blueman
    pavucontrol
    nautilus

    kdePackages.okular
    kdePackages.gwenview
    kdePackages.kdeconnect-kde
  ];
}
