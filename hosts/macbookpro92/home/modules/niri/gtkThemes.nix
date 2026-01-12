{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      package = pkgs.catppuccin-gtk.override {
        accents = ["red"];
        variant = "latte";
      };
      name = "catppuccin-latte-red-standard";
    };

    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {accent = "red";};
      name = "Papirus-Light";
    };

    cursorTheme = {
      name = "Furina-v2";
      size = 16;
    };
  };
}
