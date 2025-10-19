{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    flavors = {
      catppuccin-mocha = ./yaziThemes/catppuccin-mocha.yazi;
      catppuccin-latte = ./yaziThemes/catppuccin-latte.yazi;
    };

    theme = {
      flavor = {
        light = "catppuccin-latte";
        dark = "catppuccin-mocha";
      };
    };
  };
}
