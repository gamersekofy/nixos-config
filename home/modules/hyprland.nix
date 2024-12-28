{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./waybar.nix
    ./mako.nix
    ./walker.nix
    ./network-manager.nix
    ./rofi.nix
    ./cliphist.nix
    ./wlogout.nix
  ];

  programs.kitty.enable = true;

  home.packages = [
    inputs.hyprland-qtutils.packages."${pkgs.system}".default
    pkgs.brightnessctl
    pkgs.kdePackages.xwaylandvideobridge
    pkgs.wl-clipboard

    pkgs.libsForQt5.qt5ct
    pkgs.kdePackages.qt6ct
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, Return, exec, kitty"
          "$mod, SPACE, exec, rofi -show run"
          "$mod, E, exec, dolphin"

          "$mod SHIFT, V, togglefloating,"
          "$mod SHIFT, Q, killactive,"

          "$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
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

      input = {
        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        resize_on_border = true;
      };

      decoration = {
      };
    };

    extraConfig = ''
      exec-once = waybar
    '';
  };
}
