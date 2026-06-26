{pkgs, ...}: {
  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  programs.kde-pim = {
    enable = true;
    merkuro = true;
  };

  environment.systemPackages = with pkgs; [
    kdePackages.kdeconnect-kde
    kdePackages.plasma-nm
    kdePackages.qtwebsockets
    kdePackages.qtmultimedia
    kdePackages.filelight
    kdePackages.plasma-thunderbolt
    kdePackages.krfb

    kdePackages.kaccounts-integration
    kdePackages.kaccounts-providers
    kdePackages.kdepim-addons
    kdePackages.akonadi-calendar
    kdePackages.libkdepim

    kdePackages.signond
    kdePackages.signon-kwallet-extension

    kdePackages.kio-gdrive

    plasmusic-toolbar
    maliit-keyboard

    kdePackages.plasma-bigscreen
  ];

  programs.partition-manager.enable = true;
}
