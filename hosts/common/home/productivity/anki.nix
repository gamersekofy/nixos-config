{pkgs, ...}: {
  programs.anki = {
    enable = true;

    addons = with pkgs.ankiAddons; [
      review-heatmap
    ];

    style = "native";
    theme = "followSystem";
  };
}
