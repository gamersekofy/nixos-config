{
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    themes = {
      "catppuccin-mocha-mauve" = {
        theme.name = "Catppuccin Mocha Mauve";
        colors = {
          AlertInfo = "#a6e3a1";
          AlertWarn = "#fab387";
          AlertError = "#f38ba8";
          Annotation = "#cba6f7";
          Base = "#cdd6f4";
          Guidance = "#9399b2";
          Important = "#f38ba8";
          Title = "#cba6f7";
        };

        "catppuccin-latte-mauve" = {
          theme.name = "Catppuccin Latte Mauve";
          colors = {
            AlertInfo = "#40a02b";
            AlertWarn = "#fe640b";
            AlertError = "#fe640b";
            Annotation = "#8839ef";
            Base = "#4c4f69";
            Guidance = "#7c7f93";
            Important = "#d20f39";
            Title = "#8839ef";
          };
        };
      };
    };
  };
}
