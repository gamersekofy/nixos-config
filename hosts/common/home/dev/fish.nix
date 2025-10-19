{pkgs, ...}: {
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
}
