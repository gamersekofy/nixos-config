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
      package = pkgs.catppuccin-papirus-folders.override {accent = "mauve";};
      name = "Papirus-Dark";
    };

    cursorTheme = {
      name = "Furina-v2";
      size = 32;
    };
  };
}
