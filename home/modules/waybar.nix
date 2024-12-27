{
    programs.waybar = {
        enable = true;
	settings = {
	    mainBar = {
	        layer = "top";
		position = "top";
		height = 30;
		output = [
		    "eDP-1"
		    "HDMI-A-1"
		];
		modules-left = [ "hyprland/workspaces" "hyprland/window" ];
		modules-center = [ "tray" ];
		modules-left[ "pulseaudio" "backlight" "bluetooth" "network" "battery" "clock" ];

		"hyprland/workspaces" = {
		    on-scroll-up = "hyprctl dispatch workspace e+1";
		    on-scroll-down = "hyprctl dispatch workspace e-1";
		};

		"hyrland/window" = {
		    separate-outputs = true;
		};
	    };
	};
    };
}
