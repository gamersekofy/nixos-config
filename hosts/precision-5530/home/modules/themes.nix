{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      package = pkgs.catppuccin-gtk.override {
        accents = ["mauve"];
        variant = "mocha";
      };
      name = "catppuccin-mocha-mauve-standard";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style = {
      package = pkgs.catppuccin-kde.override {
        flavour = ["mocha"];
        accents = ["mauve"];
      };

      name = "Breeze";
    };
  };
}
