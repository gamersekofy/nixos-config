{pkgs, ...}: {
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
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

  /*catppuccin.sddm = {
    enable = true;
    flavor = "mocha";
    font = "DepartureMono Nerf Font";
    fontSize = 12;
    loginBackground = true;
    background = "${./sddmWallpaper.jpeg}";
  };*/
}
