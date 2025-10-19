{pkgs, ...}: {
  imports = [
    ../../../common/home/dev/fish.nix
    ../../../common/home/dev/eza.nix
    ../../../common/home/dev/starship.nix
    ../../../common/home/dev/direnv.nix
    ../../../common/home/dev/yazi.nix
  ];

  programs.bat = {
    enable = true;
    themes = {
      CatppuccinMocha = {
        src = ./batThemes;
        file = "CatppuccinMocha.tmTheme";
      };
      CatppuccinFrappe = {
        src = ./batThemes;
        file = "CatppuccinFrappe.tmTheme";
      };
      CatppuccinLatte = {
        src = ./batThemes;
        file = "CatppuccinLatte.tmTheme";
      };
      CatppuccinMacchiato = {
        src = ./batThemes;
        file = "CatppuccinMacchiato.tmTheme";
      };
    };
    config = {
      theme-dark = "CatppuccinMocha";
      theme-light = "CatppuccinLatte";
    };
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
}
