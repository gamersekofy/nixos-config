{
  imports = [../../../../common/home/wm-utils/waybar.nix];
  programs.waybar = {
    systemd.enable = true;
    settings = {
      mainBar = {
        modules-left = ["niri/workspaces" "niri/window" "tray"];

        "niri/workspaces" = {
          format = "{index}";
        };

        "niri/window" = {
          separate-outputs = false;
          format = " 󱂬 ";
          icon = true;
        };
      };
    };
  };
}
