{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    attachExistingSession = true;
    # exitShellOnExit = true;
    settings = {
      theme_dark = "catppuccin-mocha";
      theme_light = "catppuccin-latte";
    };
  };
}
