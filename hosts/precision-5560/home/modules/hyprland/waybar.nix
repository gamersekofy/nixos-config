{
  imports = [../../../../common/home/wm-utils/waybar];
  programs.waybar = {
    settings = {
      mainBar = {
        modules-left = ["hyprland/workspaces" "tray"];

        "hyprland/workspaces" = {
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        "hyprland/window" = {
          separate-outputs = true;
          format = " 󱂬 {class}";
          icon = true;
          rewrite = {
            "(.*) — Mozilla Firefox" = "Firefox";
          };
        };
      };
    };
  };
}
