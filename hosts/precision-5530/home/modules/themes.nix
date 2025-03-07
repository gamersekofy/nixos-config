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
    # Seems to break Plasma settings when set to true
    enable = false;
    platformTheme.name = "kde";
    style = {
      package = pkgs.catppuccin-kde.override {
        flavour = ["mocha"];
        accents = ["mauve"];
      };

      name = "Breeze";
    };
  };

  home.packages = [
    (catppuccin-kde.override {
      flavour = ["latte" "mocha"];
      accents = ["mauve"];
    })

    (catppuccin-papirus-folders.override {
      accent = "mauve";
    })
  ];
}
