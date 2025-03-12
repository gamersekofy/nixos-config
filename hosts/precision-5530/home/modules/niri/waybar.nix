{
  imports = [../../../../common/home/wm-utils/waybar];
  programs.waybar = {
    systemd.enable = true;
    settings = {
      mainBar = {
        modules-left = ["niri/workspaces" "tray"];

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            main = "󱄄";
            thunderbird = "󰛮";
            work = "󰑴";
            active = "";
            default = "";
          };
        };

        "niri/window" = {
          separate-outputs = false;
          format = "";
          icon = true;
        };
      };
    };
  };
}
