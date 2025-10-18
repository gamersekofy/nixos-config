{
  pkgs,
  ...
}: {
    services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha-mauve";
  };

  environment.systemPackages = with pkgs; [
    (catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
      font = "DepartureMono Nerd Font";
      fontSize = "12";
      background = "${../../../common/wallpapers/flowers.jpeg}";
      loginBackground = true;
    })
  ];
}
