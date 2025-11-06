{pkgs, ...}: {
  home.packages = [
    (pkgs.catppuccin-kde.override {
      flavour = ["latte" "mocha"];
      accents = ["red"];
    })

    (pkgs.catppuccin-papirus-folders.override {
      accent = "red";
    })
  ];
}
