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

      binds = with config.lib.niri.actions; {
        "Mod+Return".action = spawn "kitty";
        "Mod+Space".action = spawn "rofi" "-show" "drun" "-show-icons";

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
      };
    };
  };
}
