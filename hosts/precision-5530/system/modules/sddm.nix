{pkgs, ...}: {
  imports = [../../../common/system/sddm.nix];
  services.displayManager.sddm = {
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
