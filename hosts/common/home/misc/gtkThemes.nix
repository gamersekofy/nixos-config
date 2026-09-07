{
  pkgs,
  config,
  ...
}: {
  gtk = {
    enable = true;
    gtk2.enable = true;
    gtk3.enable = true;
    gtk4 = {
      enable = true;
      theme = config.gtk.theme;
    };

    theme = {
      package = pkgs.catppuccin-gtk.override {
        accents = ["red"];
        variant = "mocha";
      };
      name = "catppuccin-mocha-red-standard";
    };

    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {accent = "red";};
      name = "Papirus-Dark";
    };

    cursorTheme = {
      name = "Furina-v2";
      size = 32;
    };
  };
}
