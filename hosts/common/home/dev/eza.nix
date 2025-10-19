{
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };

  home.shellAliases = {
    ls = "eza --long --icons --git --git-repos --hyperlink --time-style relative --color --header";
    tree = "eza --long --icons --git --git-repos --hyperlink --time-style relative --color --header --tree";
  };
}
