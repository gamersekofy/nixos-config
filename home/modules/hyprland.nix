{pkgs, inputs, ...}: {
  programs.kitty.enable = true;
  programs.waybar.enable = true;

  home.packages = [
    inputs.hyprland-qtutils.packages."${pkgs.system}".default
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, F, exec, firefox"
	  "$mod, Return, exec, kitty"
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
    };
  };
}
