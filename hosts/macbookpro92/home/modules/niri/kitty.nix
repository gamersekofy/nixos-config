{
  programs.kitty = {
    enable = true;
    themeFile = "Borland";
    shellIntegration = {
      enableFishIntegration = true;
    };
    font = {
      name = "ANAKRON Nerd Font";
      size = 12;
    };
  };

  services.clipse.imageDisplay.type = "kitty";
}
