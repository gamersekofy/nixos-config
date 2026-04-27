{
  pkgs,
  config,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  dms-pkg = inputs.dms.packages.${system}.default;
in {
  imports = [
    ../../../../common/home/wm-utils/udiskie.nix
    ../../../../common/home/wm-utils/packages.nix

    ./dms
    ./wluma.nix
  ];

  home.packages = with pkgs; [
    xwayland-satellite

    nwg-look

    libsForQt5.qt5.qtwayland
    libsForQt5.qt5ct

    kdePackages.qtwayland
    kdePackages.qt6ct
    kdePackages.breeze
  ];

  programs.niri = {
    settings = {
      environment = {
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "gtk3";
        # DISPLAY = ":0";
      };

      prefer-no-csd = true;

      workspaces = {
        "main" = {};
        "thunderbird" = {};
        "work" = {};
      };

      switch-events = {
        # lid-close.action.spawn = ["${dms-pkg}/bin/dms" "ipc" "call" "sessionMenu" "lock"];
      };

      screenshot-path = "~/Pictures/Screenshots/Screenshot_%Y%m%d_%H%M%S.png";

      input = {
        touchpad = {
          accel-profile = "adaptive";
          accel-speed = 0.1;
          scroll-factor = 0.4;
          tap-button-map = "left-right-middle";
          dwt = true;
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
        gaps = 5;
        focus-ring.enable = false;
        border = {
          enable = true;
          width = 2;
          active = {color = "rgb(203, 166, 247)";};
          inactive = {color = "rgb(108, 112, 134)";};
        };
        default-column-width = {proportion = 1. / 2.;};
        center-focused-column = "never";

        tab-indicator = {
          place-within-column = true;
          width = 5.5;
          position = "bottom";
        };
      };

      spawn-at-startup = [
      ];

      debug = {
        honor-xdg-activation-with-invalid-serial = [];
      };

      layer-rules = [
        {
          matches = [
            {namespace = "^noctalia-overview";}
          ];
          place-within-backdrop = true;
        }
      ];

      window-rules = [
        {
          geometry-corner-radius = {
            bottom-left = 20.0;
            bottom-right = 20.0;
            top-left = 20.0;
            top-right = 20.0;
          };
          clip-to-geometry = true;
        }

        # Open Thunderbird windows on Thunderbird workspace
        {
          matches = [
            {app-id = "^thunderbird$";}
          ];
          open-on-workspace = "thunderbird";
        }

        # Float these windows
        {
          matches = [
            # Thunderbird event reminder popup
            {
              app-id = "^thunderbird$";
              title = "\d+ Reminders?$";
            }
            # IntelliJ welcome screen
            {
              app-id = "jetbrains-idea";
              title = "Welcome to IntelliJ IDEA";
            }
            # Blueman
            {
              app-id = ".blueman-manager-wrapped";
              title = "Bluetooth Devices";
            }
            # Pavucontrol
            {app-id = "org.pulseaudio.pavucontrol";}
            # KDE Polkit password popup
            {app-id = "org.kde.polkit-kde-authentication-agent-1";}
            # Thunar file explorer
            {app-id = "org.gnome.Nautilus";}
            # Kden live start screen
            {
              app-id = "org.kde.kdenlive";
              title = "Kdenlive";
            }
            # Kden live splash screen
            {
              app-id = "org.kde.kdenlive";
              title = "Splash Screen - Kdenlive";
            }
            # Qalculate-Gtk
            {
              app-id = "qalculate-gtk";
            }
          ];
          open-floating = true;
        }

        # Spotify
        {
          matches = [
            {app-id = "spotify";}
          ];
          open-maximized = true;
        }

        # Float and blur clipse window
        {
          matches = [
            {title = "clipse";}
          ];
          open-floating = true;
          opacity = 0.9;
        }

        # Increase scroll factor for kitty windows
        {
          matches = [
            {app-id = "kitty";}
          ];
          scroll-factor = 3;
        }
      ];

      binds = with config.lib.niri.actions;
        {
          "Mod+Return".action = spawn "${pkgs.ghostty}/bin/ghostty" "+new-window";
          "Mod+Space".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "spotlight" "toggle";
          "Mod+V".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "clipboard" "toggle";
          # "Mod+Period".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "launcher" "emoji";
          # "Mod+Tab".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "launcher" "windows";
          "Mod+A".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "control-center" "toggle";

          "Mod+Shift+Slash".action = show-hotkey-overlay;

          "Mod+N".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "notifications" "toggle";
          "Mod+Shift+N".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "notifications" "toggleDoNotDisturb";

          # Launch file explorer
          "Mod+E".action = spawn "nautilus";

          # Lock screen
          "Mod+L".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "lock" "lock";

          "XF86AudioRaiseVolume" = {
            action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "audio" "increment";
            allow-when-locked = true;
          };
          "XF86AudioLowerVolume" = {
            action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "audio" "decrement";
            allow-when-locked = true;
          };
          "XF86AudioMute" = {
            action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "audio" "mute";
            allow-when-locked = true;
          };

          # "Mod+XF86AudioRaiseVolume" = {
          #   action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "volume" "increaseInput";
          #   allow-when-locked = true;
          # };
          # "Mod+XF86AudioLowerVolume" = {
          #   action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "volume" "decreaseInput";
          #   allow-when-locked = true;
          # };
          "Mod+XF86AudioMute" = {
            action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "audio" "micmute";
            allow-when-locked = true;
          };

          "XF86AudioNext".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "mpris" "next";
          "XF86AudioPause".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "mpris" "playPause";
          "XF86AudioPlay".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "mpris" "playPause";
          "XF86AudioPrev".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "mpris" "previous";

          "XF86MonBrightnessUp".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "brightness" "increment" "10";
          "XF86MonBrightnessDown".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "brightness" "decrement" "10";

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

          "Mod+TouchpadScrollDown".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "audio" "increment";
          "Mod+TouchpadScrollUp".action = spawn "${dms-pkg}/bin/dms" "ipc" "call" "audio" "decrement";

          "Mod+1".action = focus-workspace 1;
          "Mod+2".action = focus-workspace 2;
          "Mod+3".action = focus-workspace 3;
          "Mod+4".action = focus-workspace 4;
          "Mod+5".action = focus-workspace 5;
          "Mod+6".action = focus-workspace 6;
          "Mod+7".action = focus-workspace 7;
          "Mod+8".action = focus-workspace 8;
          "Mod+9".action = focus-workspace 9;

          # Commented due to https://github.com/sodiboo/niri-flake/issues/1018
          # "Mod+Shift+1".action = move-column-to-workspace 1;
          # "Mod+Shift+2".action = move-column-to-workspace 2;
          # "Mod+Shift+3".action = move-column-to-workspace 3;
          # "Mod+Shift+4".action = move-column-to-workspace 4;
          # "Mod+Shift+5".action = move-column-to-workspace 5;
          # "Mod+Shift+6".action = move-column-to-workspace 6;
          # "Mod+Shift+7".action = move-column-to-workspace 7;
          # "Mod+Shift+8".action = move-column-to-workspace 8;
          # "Mod+Shift+9".action = move-column-to-workspace 9;

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

          "Mod+W".action = toggle-column-tabbed-display;

          "Mod+Shift+S".action.screenshot = [];
          "Mod+Print".action.screenshot-screen = [];
          "Alt+Print".action.screenshot-window = [];

          "Mod+Escape" = {
            allow-inhibiting = false;
            action = toggle-keyboard-shortcuts-inhibit;
          };

          "Ctrl+Alt+Delete".action = quit;

          "Mod+Shift+P".action = power-off-monitors;

          # Instant Eyedropper Reborn bindings
          "Mod+Alt+C".action = spawn "pkill" "-SIGUSR1" "ie-r";
          "Mod+Alt+H".action = spawn "pkill" "-SIGUSR2" "ie-r";
        }
        // # Workaround for issue 1018
        (builtins.listToAttrs (map (n: {
          name = "Mod+Shift+${builtins.toString n}";
          value = {
            action.move-window-to-workspace = n;
            repeat = false;
          };
        }) (builtins.genList (x: x + 1) 9)));
    };
  };
}
