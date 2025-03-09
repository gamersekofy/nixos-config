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
          "DP-1"
        ];
        modules-center = ["clock"];
        modules-right = ["privacy" "network" "pulseaudio" "backlight" "battery" "custom/power"];

        # ----------------------------------------------

        "tray" = {
          icon-size = 24;
          spacing = 7;
        };

        # ----------------------------------------------

        "clock" = {
          timezone = "America/Los_Angeles";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%H:%M}";
        };

        # ----------------------------------------------

        "privacy" = {
            icon-spacing = 7;
            icon-size = 15;

        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = " {volume}%";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "pavucontrol &";
        };

        "backlight" = {
          format = "󰃠 {percent}%";
        };

        "bluetooth" = {
          format-disabled = "󰂲 Disabled";
          format-off = "󰂲 Off";
          format-on = "󰂯 On";
          format-connected = "󰂱 Connected";
          tooltip-format-connected = "Connected to {device_alias}";
          format-connected-battery = "󰂱 {device_battery_percentage}%";
        };

        "network" = {
          format = "{ifname}";
          format-ethernet = "󰈀";
          tooltip-format-ethernet = "{ifname}";
          format-wifi = "{icon} Connected";
          tooltip-format-wifi = "Connected to {essid} with IP: {ipaddr} and signal strength: {signalStrength}";
          format-disconnected = "󰤭 Offline";
          tooltip-format-disconnected = "Disconnected";
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };

          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-icons = ["" "" "" "" ""];
        };

        "custom/power" = {
          tooltip = false;
          on-click = "wlogout &";
          format = "";
        };
      };
    };

    style = ''
    @define-color base #1e1e2e;
    @define-color mantle #181825;
    @define-color crust #11111b;

    @define-color text #cdd6f4;
    @define-color subtext0 #a6adc8;
    @define-color subtext1 #bac2de;

    @define-color surface0 #313244;
    @define-color surface1 #45475a;
    @define-color surface2 #585b70;

    @define-color overlay0 #6c7086;
    @define-color overlay1 #7f849c;
    @define-color overlay2 #9399b2;

    @define-color blue #89b4fa;
    @define-color lavender #b4befe;
    @define-color sapphire #74c7ec;
    @define-color sky #89dceb;
    @define-color teal #94e2d5;
    @define-color green #a6e3a1;
    @define-color yellow #f9e2af;
    @define-color peach #fab387;
    @define-color maroon #eba0ac;
    @define-color red #f38ba8;
    @define-color mauve #cba6f7;
    @define-color pink #f5c2e7;
    @define-color flamingo #f2cdcd;
    @define-color rosewater #f5e0dc;

    * {
    	font-family: JetBrainsMono NF;
    	font-size: 15px;
    }

    #battery {
    	color: @base;
    	background-color: @teal;
    	margin: 5px;
    	padding: 5px;
    }

    #battery.charging {
    	background-color: @green;
    	color: @base;
    }

    #battery.warning:not(.charging),
    #battery.critical:not(.charging) {
    	background-color: @red;
    	color: @base;
    }

    #waybar {
    	background: @base;
    	color: @text;
    	margin: 1rem;
    }

    #workspaces {
    	margin: 5px;
    	background-color: @surface0;
    	margin-left: 0.5rem;
    	border-radius: 0rem;
    }

    #workspaces button {
    	color: @base;
    	border-radius: 0rem;
	padding: 3px;
	background-color: @mauve;
    }

    #workspaces button.active {
    	color: @text;
    	background-color: @base;
    }

    #workspaces button:hover {
    	color: @base;
    	border-radius: 0rem;
    }

    #tray {
    	background-color: @surface0;
    	border-radius: 0rem;
    	margin: 5px;
	padding: 5px;
    }

    #clock {
    	color: @base;
    	background-color: @flamingo;
    	border-radius: 0rem;
    	margin: 5px;
    	padding: 5px;
    }

    #privacy {
        background-color: @pink;
	padding: 5px;
	margin: 5px;
	color: @base;
    }

    #backlight {
    	background-color: @peach;
    	margin: 5px;
    	padding: 5px;
    	color: @base;
    }

    #bluetooth.off {
    	color: @red;
    }

    #bluetooth.on {
    	color: @blue;
    }

    #bluetooth.connected {
    	color: @blue;
    }

    #pulseaudio {
    	background-color: @lavender;
    	color: @base;
    	border-radius: 0px;
    	margin: 5px;
    	padding: 5px;
    }

    #pulseaudio.muted {
    	background-color: @maroon;
    	color: @base;
    }

    #custom-music {
    	color: @mauve;
    	border-radius: 1rem;
    }

    #custom-lock {
    	border-radius: 1rem 0px 0px 1rem;
    	color: @lavender;
    }

    #custom-power {
    	margin: 5px;
    	color: @base;
    	border-radius: 0rem;
    	background-color: @red;
    	padding-left: 10px;
    	padding-right: 13px;
    }

    #network {
    	color: @text;
    	background-color: @surface1;
    	margin: 5px;
    	padding: 5px;
    }

    #network.wifi,
    #network.ethernet,
    #network.linked {
    	background-color: @blue;
    	color: @base;
    }

    #network.disabled {
    	color: @base;
    	background-color: @red;
    }

    #network.disconnected {
    	color: @base;
    	background-color: @red;
    }
    '';
  };
}
