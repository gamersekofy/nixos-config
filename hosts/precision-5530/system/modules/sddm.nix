{pkgs, ...}: {
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha";
  };

  environment.systemPackages = with pkgs; [
    (catppuccin-sddm.override {
      flavor = "mocha";
      font = "DepartureMono Nerd Font";
      fontSize = "12";
      background = "${./sddmWallpaper.jpeg}";
      loginBackground = true;
    })
  ];
}
