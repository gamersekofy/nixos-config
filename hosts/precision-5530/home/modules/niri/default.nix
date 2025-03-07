{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../../../common/home/wm-utils/kitty.nix
    ../../../../common/home/wm-utils/mako.nix
    ../../../../common/home/wm-utils/network-manager.nix
    ../../../../common/home/wm-utils/cliphist.nix
    ../../../../common/home/wm-utils/wlogout.nix
    ../../../../common/home/wm-utils/wlsunset.nix
    ../../../../common/home/wm-utils/udiskie.nix
    ../../../../common/home/wm-utils/packages.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    swww
    xwayland-satellite
  ];

  programs.niri = {
    settings = {
      environment = {
        QT_QPA_PLATFORM = "wayland";
        DISPLAY = ":0";
      };
      outputs = {
        "eDP-1" = {
          enable = true;
          mode.width = 3840;
          mode.height = 2160;
          scale = 2;
          position.x = 0;
          position.y = 0;
        };
      };

      input = {
        touchpad = {
                accel-profile = "adaptive";
                accel-speed = 0.1;
                scroll-factor = 0.2;
                tap-button-map = "left-right-middle";
        };

        mouse = {
            accel-profile = "flat";
            accel-speed = 0.1;
        };

        focus-follows-mouse = {
            enable = true;
            max-scroll-amount = "25%";
        };
      };

      layout = {
        gaps = 10;
        focus-ring.enable = false;
        border = {
          enable = true;
          width = 2;
          active = {color = "rgb(203, 166, 247)";};
          inactive = {color = "rgb(108, 112, 134)";};
        };
        default-column-width = {proportion = 1. / 2.;};
        center-focused-column = "never";
      };

      spawn-at-startup = [
        {command = ["waybar"];}
        {command = ["xwayland-satellite"];}
        {command = ["swww-daemon"];}
        {command = ["swww" "img" "~/Pictures/FlowersWallpaper.jpeg"];}
      ];

      window-rules = [
        {
            geometry-corner-radius = {
                bottom-left = 12.0;
                bottom-right = 12.0;
                top-left = 12.0;
                top-right = 12.0;
            };
            clip-to-geometry = true;
        }

        {
            matches = [{app-id = "org.pulseaudio.pavucontrol";}];
            open-floating = true;
        }
      ];

      binds = with config.lib.niri.actions; {
        "Mod+Return".action = spawn "kitty";
        "Mod+Space".action = spawn "rofi" "-show" "drun" "-show-icons";
        "Mod+V".action = spawn "rofi" "-modi" "clipboard:/home/uzair/Documents/nixos-config/hosts/common/home/wm-utils/cliphist-rofi-img" "-show" "clipboard" "-show-icons";
        "Mod+Period".action = spawn "rofi" "-modi" "\"emoji:rofimoji\"" "-show emoji";

        "Mod+Shift+Slash".action = show-hotkey-overlay;

        "XF86AudioRaiseVolume" = {
          action = spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "2%+";
          allow-when-locked = true;
        };
        "XF86AudioLowerVolume" = {
          action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "2%-";
          allow-when-locked = true;
        };
        "XF86AudioMute" = {
          action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
          allow-when-locked = true;
        };
        "XF86AudioMicMute" = {
          action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
          allow-when-locked = true;
        };

        "XF86AudioNext".action = spawn "playerctl" "next";
        "XF86AudioPause".action = spawn "playerctl" "play-pause";
        "XF86AudioPlay".action = spawn "playerctl" "play-pause";
        "XF86AudioPrev".action = spawn "playerctl" "previous";

        "XF86MonBrightnessUp".action = spawn "brightnessctl" "s" "2%+";
        "XF86MonBrightnessDown".action = spawn "brightnessctl" "s" "2%-";

        "Mod+Q".action = close-window;

        "Mod+Left".action = focus-column-left;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;
        "Mod+Right".action = focus-column-right;

        "Mod+Ctrl+Left".action = move-column-left;
        "Mod+Ctrl+Down".action = move-window-down;
        "Mod+Ctrl+Up".action = move-window-up;
        "Mod+Ctrl+Right".action = move-column-right;

        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;
        "Mod+Ctrl+Home".action = move-column-to-first;
        "Mod+Ctrl+End".action = move-column-to-last;

        "Mod+Page_Down".action = focus-workspace-down;
        "Mod+Page_Up".action = focus-workspace-up;
        "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
        "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;

        "Mod+Shift+Page_Down".action = move-workspace-down;
        "Mod+Shift+Page_Up".action = move-workspace-up;

        "Mod+WheelScrollDown" = {
            action = focus-workspace-down;
            cooldown-ms = 150;
        };

        "Mod+WheelScrollUp" = {
            action = focus-workspace-up;
            cooldown-ms = 150;
        };

        "Mod+Ctrl+WheelScrollDown" = {
            action = move-column-to-workspace-down;
            cooldown-ms = 150;
        };

        "Mod+Ctrl+WheelScrollUp" = {
            action = move-column-to-workspace-up;
            cooldown-ms = 150;
        };

        "Mod+WheelScrollRight".action = focus-column-right;
        "Mod+WheelScrollLeft".action = focus-column-left;
        "Mod+Ctrl+WheelScrollRight".action = move-column-right;
        "Mod+Ctrl+WheelScrollLeft".action = move-column-left;

        "Mod+Shift+WheelScrollDown".action = focus-column-right;
        "Mod+Shift+WheelScrollUp".action = focus-column-left;
        "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
        "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

        "Mod+TouchpadScrollDown".action = spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "2%+";
        "Mod+TouchpadScrollUp".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "2%-";

        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;

        "Mod+Shift+1".action = move-column-to-workspace 1;
        "Mod+Shift+2".action = move-column-to-workspace 2;
        "Mod+Shift+3".action = move-column-to-workspace 3;
        "Mod+Shift+4".action = move-column-to-workspace 4;
        "Mod+Shift+5".action = move-column-to-workspace 5;
        "Mod+Shift+6".action = move-column-to-workspace 6;
        "Mod+Shift+7".action = move-column-to-workspace 7;
        "Mod+Shift+8".action = move-column-to-workspace 8;
        "Mod+Shift+9".action = move-column-to-workspace 9;

        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;

        "Mod+Ctrl+R".action = reset-window-height;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;

        "Mod+Ctrl+F".action = expand-column-to-available-width;

        "Mod+C".action = center-column;

        "Mod+Minus".action = set-column-width "-5%";
        "Mod+Equal".action = set-column-width "+5%";

        "Mod+Shift+Minus".action = set-window-height "-5%";
        "Mod+Shift+Equal".action = set-window-height "+5%";

        "Mod+Shift+V".action = toggle-window-floating;
        "Alt+Tab".action = switch-focus-between-floating-and-tiling;

        "Mod+W".action = toggle-column-tabbed-display;

        "Mod+Shift+S".action = screenshot;
        "Mod+Print".action = screenshot-screen;
        "Alt+Print".action = screenshot-window;

        "Mod+Escape" = {
            allow-inhibiting = false;
            action = toggle-keyboard-shortcuts-inhibit;
        };

        "Ctrl+Alt+Delete".action = quit;

        "Mod+Shift+P".action = power-off-monitors;
      };
    };
  };
}
