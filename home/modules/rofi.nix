{pkgs, ... }: {
    programs.rofi = {
    	enable = true;
	cycle = false;
	plugins = with pkgs; [
	    rofi-emoji-wayland
	    rofi-calc
	    rofi-bluetooth
	    rofi-screenshot
	    rofi-power-menu
	];
    };
}
