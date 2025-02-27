{inputs, ...}: {
  imports = [
    inputs.hyprpanel.homeManagerModules.hyprpanel
  ];

  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;
    hyprland.enable = true;

    theme = "catppuccin_mocha";

    layout = {
      "bar.layouts" = {
        "0" = {
          left = ["dashboard" "workspaces"];
          middle = ["media"];
          right = ["volume" "systray" "notifications"];
        };
      };
    };

    settings = {
      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;

      menus = {
        clock = {
          time = {
            military = true;
            hideSeconds = true;
          };
          weather.unit = "imperial";
        };

	dashboard = {
		directories.enabled = true;
	};
      };

      theme.font = {
      	name = "CaskaydiaCove NF";
	size = "16px";
      };
    };
  };
}
