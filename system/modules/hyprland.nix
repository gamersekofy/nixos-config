{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.systemPackages = with pkgs; [
    # Default Hyprland terminal
    kitty
    alacritty

    waybar

    # Notification things
    mako
    libnotify

    # For wallpapers
    hyprpaper

    # App launcher
    rofi-wayland

    networkmanagerapplet

    playerctl
    brightnessctl

    # Screenshot and copy stuff
    grim
    slurp
    wl-clipboard

    # Needed to display workspaces in Waybar
    hyprland-workspaces

    # For night light
    wlsunset

    kdePackages.qt6ct
    libsForQt5.qt5ct
    catppuccin-qt5ct

    wlogout

    xfce.thunar
    blueman
  ];
}
