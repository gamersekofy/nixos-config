{pkgs, ...}: {
  # Enable Fish instead of others
  programs.fish = {
    enable = true;
    functions = {
      gitignore = "touch .gitignore && curl -sL https://www.gitignore.io/api/$argv >> .gitignore";
      finit = "nix flake init --template \"https://flakehub.com/f/the-nix-way/dev-templates/*#$argv\"";
    };

    generateCompletions = true;

    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
          sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
        };
      }
    ];

    shellAbbrs = {
      gs = "git status";
      ga = "git add";
      gc = "git commit -m";
    };

    shellInit = "set -g fish_greeting";
  };

  # Enable a better ls replacement
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };

  # Enable the starship prompt and use the default config
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Set aliases to replace ls with eza
  home.shellAliases = {
    ls = "eza --long --icons --git --git-repos --hyperlink --time-style relative --color --header";
    tree = "eza --long --icons --git --git-repos --hyperlink --time-style relative --color --header --tree";
  };

  # Enable direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";
  };

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
      theme = "CatppuccinMocha";
    };
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  # Enable powershell
  home.packages = with pkgs; [
    powershell
  ];
}
