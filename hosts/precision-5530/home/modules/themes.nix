{pkgs, inputs, ...}: {
  imports = [inputs.catppuccin.homeManagerModules.catppuccin];
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
    enable = true;
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

    pkgs.kdePackages.qtstyleplugin-kvantum
    pkgs.libsForQt5.qtstyleplugin-kvantum
  ];

  catppuccin.kvantum = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
      apply = true;
  };
}
