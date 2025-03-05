{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./kitty.nix
    ./waybar.nix
    ./mako.nix
    ./walker.nix
    ./network-manager.nix
    ./cliphist.nix
    ./wlogout.nix
    ./wlsunset.nix
    ./hyprpaper.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./udiskie.nix
  ];

  home.packages = [
    inputs.hyprland-qtutils.packages."${pkgs.system}".default
    pkgs.brightnessctl
    pkgs.kdePackages.xwaylandvideobridge
    pkgs.wl-clipboard
    pkgs.playerctl

    pkgs.libsForQt5.qt5.qtwayland
    pkgs.kdePackages.qtwayland

    pkgs.rofi-wayland
    pkgs.rofimoji

    pkgs.blueman
    pkgs.pavucontrol
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      # Define Catppuccin Mocha Mauve colors
      "$rosewater" = "rgb(f5e0dc)";
      "$rosewaterAlpha" = "f5e0dc";

      "$flamingo" = "rgb(f2cdcd)";
      "$flamingoAlpha" = "f2cdcd";

      "$pink" = "rgb(f5c2e7)";
      "$pinkAlpha" = "f5c2e7";

      "$mauve" = "rgb(cba6f7)";
      "$mauveAlpha" = "cba6f7";

      "$red" = "rgb(f38ba8)";
      "$redAlpha" = "f38ba8";

      "$maroon" = "rgb(eba0ac)";
      "$maroonAlpha" = "eba0ac";

      "$peach" = "rgb(fab387)";
      "$peachAlpha" = "fab387";

      "$yellow" = "rgb(f9e2af)";
      "$yellowAlpha" = "f9e2af";

      "$green" = "rgb(a6e3a1)";
      "$greenAlpha" = "a6e3a1";

      "$teal" = "rgb(94e2d5)";
      "$tealAlpha" = "94e2d5";

      "$sky" = "rgb(89dceb)";
      "$skyAlpha" = "89dceb";

      "$sapphire" = "rgb(74c7ec)";
      "$sapphireAlpha" = "74c7ec";

      "$blue" = "rgb(89b4fa)";
      "$blueAlpha" = "89b4fa";

      "$lavender" = "rgb(b4befe)";
      "$lavenderAlpha" = "b4befe";

      "$text" = "rgb(cdd6f4)";
      "$textAlpha" = "cdd6f4";

      "$subtext1" = "rgb(bac2de)";
      "$subtext1Alpha" = "bac2de";

      "$subtext0" = "rgb(a6adc8)";
      "$subtext0Alpha" = "a6adc8";

      "$overlay2" = "rgb(9399b2)";
      "$overlay2Alpha" = "9399b2";

      "$overlay1" = "rgb(7f849c)";
      "$overlay1Alpha" = "7f849c";

      "$overlay0" = "rgb(6c7086)";
      "$overlay0Alpha" = "6c7086";

      "$surface2" = "rgb(585b70)";
      "$surface2Alpha" = "585b70";

      "$surface1" = "rgb(45475a)";
      "$surface1Alpha" = "45475a";

      "$surface0" = "rgb(313244)";
      "$surface0Alpha" = "313244";

      "$base" = "rgb(1e1e2e)";
      "$baseAlpha" = "1e1e2e";

      "$mantle" = "rgb(181825)";
      "$mantleAlpha" = "181825";

      "$crust" = "rgb(11111b)";
      "$crustAlpha" = "11111b";
      # ------------------------------ #

      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$files" = "dolphin";
      "$menu" = "rofi -show drun -show-icons";
      #"$menu" = "walker";
      bind =
        [
          "$mod, Return, exec, $terminal"
          "$mod, SPACE, exec, $menu"
          "$mod, E, exec, $files"

          "$mod SHIFT, V, togglefloating,"
          "$mod SHIFT, Q, killactive,"

          "$mod, V, exec, rofi -modi clipboard:/home/uzair/Documents/cliphist-rofi-img -show clipboard -show-icons"

          # Emoji
          "$mod, PERIOD, exec, rofi -modi \"emoji:rofimoji\" -show emoji"

          # Scroll through existing workspaces with mod + scroll
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          # Switch between windows in a floating workspace
          "ALT, Tab, cyclenext,"
          "ALT, Tab, bringactivetotop,"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 2%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 2%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"

        # Laptop lid open and close event
        ", switch:Lid Switch, exec, hyprlock"
        ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
        ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, 3840x2160, 0x0, 2\""
      ];

      windowrulev2 = [
      	"float, class:org.pulseaudio.pavucontrol"
      ];

      input = {
        kb_layout = "us";
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.4;
        };
      };

      general = {
        resize_on_border = true;

        gaps_in = 5;
        gaps_out = 5;

        border_size = 2;

        "col.active_border" = "rgba($mauveAlphaee)";
        "col.inactive_border" = "rgba($overlay1Alphaee)";
      };

      decoration = {
        rounding = 5;

        blur = {
          enabled = false;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 450;
      };
    };

    extraConfig = ''
      exec-once = waybar
      env = NIXOS_OZONE_WL,1
      env = ELECTRON_OZONE_PLATFORM_HINT,wayland
    '';
  };
}
