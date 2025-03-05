{pkgs, ...}: {
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm = {
  	enable = true;
	wayland.enable = true;
	theme = "catppuccin-mocha";
  };

  environment.systemPackages = with pkgs; [
    kdePackages.kdeconnect-kde
    kdePackages.plasma-nm
    kdePackages.qtwebsockets
    kdePackages.qtmultimedia
    plasmusic-toolbar
    kdePackages.plasma-browser-integration
    kdePackages.filelight
    maliit-keyboard

    (catppuccin-kde.override {
      flavour = ["latte" "mocha"];
      accents = ["mauve"];
    })

    (catppuccin-papirus-folders.override {
      accent = "mauve";
    })

    (catppuccin-sddm.override {
      flavor = "mocha";
      font = "DepartureMono Nerd Font";
      fontSize = "12";
      background = "${./sddmWallpaper.jpg}";
      loginBackground = true;
    })
  ];
}
