{pkgs, ...}: {
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm.wayland.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kdeconnect-kde
    kdePackages.plasma-nm
    kdePackages.qtwebsockets
    kdePackages.qtmultimedia
    plasmusic-toolbar
    plasma-browser-integration
    kdePackages.filelight

    (catppuccin-kde.override {
      flavour = ["latte" "mocha"];
      accents = ["mauve"];
    })

    (catppuccin-papirus-folders.override {
      accent = "mauve";
    })
  ];
}
