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
        modules-right = ["network" "pulseaudio" "backlight" "battery" "custom/power"];

        # ----------------------------------------------

        "tray" = {
          icon-size = 21;
          spacing = 7;
        };

        # ----------------------------------------------

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

          format = "{icon}{capacity}%";
          format-charging = " {capacity}%";
          format-icons = ["" "" "" "" ""];
        };

        "clock" = {
          timezone = "America/Los_Angeles";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = " {:%H:%M} 󰃭 {:%A %b %e}";
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
      	 color: @green;
      }

      #battery.warning:not(.charging), #battery.critical:not(.charging) {
         background-color: @red;
      	 color: @base;
      }

      #waybar {
        background: transparent;
        color: @text;
        margin: 5px 5px;
      }

      #workspaces {
        border-radius: 1rem;
        margin: 5px;
        background-color: @surface0;
        margin-left: 1rem;
      }

      #workspaces button {
        color: @text;
        border-radius: 1rem;
        padding: 0.4rem;
      }

      #workspaces button.active {
        color: @mauve;
        border-radius: 1rem;
      }

      #workspaces button:hover {
        color: @sapphire;
        border-radius: 1rem;
      }

      #custom-music,
      #tray,
      #backlight,
      #clock,
      #battery,
      #pulseaudio,
      #custom-lock,
      #clock {
        color: @blue;
        border-radius: 0px 1rem 1rem 0px;
        margin-right: 1rem;
      }

      #backlight {
        color: @yellow;
      }

      #backlight, #battery {
          border-radius: 0;
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
        color: @maroon;
        border-radius: 1rem 0px 0px 1rem;
        margin-left: 1rem;
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
          margin-right: 1rem;
          border-radius: 0px 1rem 1rem 0px;
          color: @red;
      }

      #tray {
        margin-right: 1rem;
        border-radius: 1rem;
      }

      #network {
         color: @text;
      }

      #network.disabled {
          color: @red;
      }

      #network.disconnected {
          color: @red;
      }
    '';
  };
}
