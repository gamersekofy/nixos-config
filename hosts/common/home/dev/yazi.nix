{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    flavors = {
      catppuccin-mocha = ./yazi-themes/catppuccin-mocha.yazi;
      catppuccin-latte = ./yazi-themes/catppuccin-latte.yazi;
    };

    theme = {
      flavor = {
        light = "catppuccin-latte";
        dark = "catppuccin-mocha";
      };
    };
  };
}
