{
  pkgs,
  config,
  ...
}: {
  programs.anki = {
    enable = true;

    addons = with pkgs.ankiAddons; [
      review-heatmap
    ];

    style = "native";
    theme = "followSystem";

    profiles = {
      "Uzair" = {
        default = true;
        sync = {
          autoSync = true;
          keyFile = "${config.home.homeDirectory}/Secrets/ankiKeyFile";
        };
      };
    };
  };
}
