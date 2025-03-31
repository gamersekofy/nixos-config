{pkgs, ...}: {
  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kdeconnect-kde
    kdePackages.plasma-nm
    kdePackages.qtwebsockets
    kdePackages.qtmultimedia
    plasmusic-toolbar
    kdePackages.filelight
    maliit-keyboard
  ];
}
