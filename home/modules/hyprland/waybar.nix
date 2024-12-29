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
        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["tray"];
        modules-right = ["pulseaudio" "backlight" "bluetooth" "network" "battery" "clock" "custom/power"];

        "hyprland/workspaces" = {
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        "hyrland/window" = {
          separate-outputs = true;
        };

	"custom/power" = {
	  tooltip = false;
	  on-click = "wlogout &";
	  format = "";
	};
      };
    };

    style = ''
      @define-color base   #1e1e2e;
      @define-color mantle #181825;
      @define-color crust  #11111b;

      @define-color text     #cdd6f4;
      @define-color subtext0 #a6adc8;
      @define-color subtext1 #bac2de;

      @define-color surface0 #313244;
      @define-color surface1 #45475a;
      @define-color surface2 #585b70;

      @define-color overlay0 #6c7086;
      @define-color overlay1 #7f849c;
      @define-color overlay2 #9399b2;

      @define-color blue      #89b4fa;
      @define-color lavender  #b4befe;
      @define-color sapphire  #74c7ec;
      @define-color sky       #89dceb;
      @define-color teal      #94e2d5;
      @define-color green     #a6e3a1;
      @define-color yellow    #f9e2af;
      @define-color peach     #fab387;
      @define-color maroon    #eba0ac;
      @define-color red       #f38ba8;
      @define-color mauve     #cba6f7;
      @define-color pink      #f5c2e7;
      @define-color flamingo  #f2cdcd;
      @define-color rosewater #f5e0dc;

      * {
         font-family: JetBrainsMono NF;
	 font-size: 15px;
      }

      #custom-power {
         background-color: @base;
	 color: @red;
	 padding: 0.5rem 1rem;
	 margin: 5px 0;
	 border-radius: 5px 20px 20px 5px;
      }

      #battery {
         color: @green;
      }

      #battery.charging {
         background-color: @green;
	 color: @base;
      }

      #battery.warning:not(.charging) {
         background-color: @red;
	 color: @base;
      }
    '';
  };
}
