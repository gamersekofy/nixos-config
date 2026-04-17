{pkgs, ...}: {
  home.packages = with pkgs; [
    blueman
    pavucontrol
    nautilus

    kdePackages.okular
    kdePackages.gwenview
    kdePackages.kdeconnect-kde
  ];
}
