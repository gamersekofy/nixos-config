{pkgs, ...}: {
  home.packages = with pkgs; [
    blueman
    pavucontrol
    nautilus
    wl-clipboard

    kdePackages.okular
    kdePackages.gwenview
    kdePackages.kdeconnect-kde
  ];
}
