{
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    shellIntegration = {
      enableFishIntegration = true;
    };
    font = {
      name = "CaskaydiaCove Nerd Font";
      size = 12;
    };
  };

  services.clipse.imageDisplay.type = "kitty";
}
