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

    iconTheme = {
      package = (pkgs.catppuccin-papirus-folders.override {accent = "mauve";});
      name = "Papirus-Dark";
    };
  };

  qt = {
    # Seems to break Plasma settings when set to true
    enable = false;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  home.packages = [
    (pkgs.catppuccin-kde.override {
      flavour = ["latte" "mocha"];
      accents = ["mauve"];
    })

    (pkgs.catppuccin-papirus-folders.override {
      accent = "mauve";
    })
  ];

  #catppuccin.kvantum = {
  #    enable = true;
  #    flavor = "mocha";
  #    accent = "mauve";
  #    apply = true;
  #};
}
