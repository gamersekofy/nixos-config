{
  programs.bat = {
    enable = true;
    themes = {
      CatppuccinMocha = {
        src = ./bat-themes;
        file = "CatppuccinMocha.tmTheme";
      };
      CatppuccinFrappe = {
        src = ./bat-themes;
        file = "CatppuccinFrappe.tmTheme";
      };
      CatppuccinLatte = {
        src = ./bat-themes;
        file = "CatppuccinLatte.tmTheme";
      };
      CatppuccinMacchiato = {
        src = ./bat-themes;
        file = "CatppuccinMacchiato.tmTheme";
      };
    };
    config = {
      theme-dark = "CatppuccinMocha";
      theme-light = "CatppuccinLatte";
    };
  };
}
