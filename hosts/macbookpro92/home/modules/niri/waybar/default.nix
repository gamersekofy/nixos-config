{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 20;
        spacing = 10;
        output = [
          "eDP-1"
          "HDMI-A-1"
          "DP-1"
          "LVDS-1" #mbp display
        ];
        modules-left = ["niri/workspaces"];
        modules-center = ["mpris" "privacy"];
        modules-right = ["tray" "custom/notification" "pulseaudio" "backlight" "battery" "clock" "custom/power"];

        # ----------------------------------------------

        "niri/workspaces" = {
          format = "{index}";
          format-icons = {
            active = "󰋇 ";
            default = "";
          };
        };

        "tray" = {
          icon-size = 20;
          spacing = 7;
        };

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 24;
          icon-theme = "Papirus-Dark";
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
        };

        # ----------------------------------------------

        "mpris" = {
          format = "{player_icon} {title}";
          tooltip-format = "{status} {title} {dynamic} on {player}";
          format-paused = "{player_icon} <s>{title}</s>";
          player-icons = {
            default = "󰎅";
            spotify = "󰓇";
            firefox = "󰈹";
          };
        };

        "clock" = {
          timezone = "America/Los_Angeles";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%H:%M %a %b %d }";
        };

        "privacy" = {
          icon-spacing = 7;
          icon-size = 10;
        };

        # ----------------------------------------------

        "custom/notification" = {
          tooltip = false;
          format = "NOTIF {}";
          format-dnd-none = "DND {}";
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
          format = "VOL {volume}%";
          format-muted = "MUTE {volume}%";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "pavucontrol &";
        };

        "backlight" = {
          format = "BL {percent}%";
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

          format = "BAT {capacity}%";
          format-charging = "BAT +{capacity}%";
          format-icons = ["" "" "" "" ""];
        };

        "custom/power" = {
          tooltip = false;
          on-click = "wlogout &";
          format = "PWR";
        };
      };
    };

    style = builtins.readFile ./style_boxy.css;
  };
}
