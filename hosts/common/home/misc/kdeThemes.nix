{pkgs, ...}: {
  home.packages = [
    (pkgs.catppuccin-kde.override {
      flavour = ["latte" "mocha"];
      accents = ["mauve"];
    })

    (pkgs.catppuccin-papirus-folders.override {
      accent = "mauve";
    })
  ];
}
