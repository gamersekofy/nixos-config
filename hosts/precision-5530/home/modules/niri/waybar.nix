{
  imports = [../../../../common/home/wm-utils/waybar];
  programs.waybar = {
    systemd.enable = true;
    settings = {
      mainBar = {
        modules-left = ["niri/workspaces" "tray" "wlr/taskbar"];

        "niri/workspaces" = {
          format = "{index}";
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

	"wlr/taskbar" = {
	  format = "{icon}";
	  icon-size = 24;
	  icon-theme = "Papirus-Dark";
	  tooltip-format = "{title}";
	  on-click = "activate";
	  on-click-middle = "close";
	};
      };
    };
  };
}
