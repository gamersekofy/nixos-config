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
        modules-center = ["clock" "privacy"];
        modules-right = ["custom/notification" "network" "pulseaudio" "backlight" "battery" "custom/power"];

        # ----------------------------------------------

        "tray" = {
          icon-size = 24;
          spacing = 7;
        };

        # ----------------------------------------------

        "clock" = {
          timezone = "America/Los_Angeles";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%H:%M - %a, %b %d}";
        };

        # ----------------------------------------------

        "privacy" = {
          icon-spacing = 7;
          icon-size = 15;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{} {icon}";
          format-icons = {
            notification = "";
            none = "";
            dnd-notification = "";
            dnd-none = "";
            inhibited-notification = "";
            inhibited-none = "";
            dnd-inhibited-notification = "";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb -s";
          on-click = "swaync-client -t -swb";
          on-click-right = "swaync-client -d -sw";
          escape = true;
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
          format-wifi = "{icon} {essid}";
          tooltip-format-wifi = "Connected with IP {ipaddr} and signal strength: {signalStrength}";
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

    style = builtins.readFile ./style_boxy.css;
  };
}
