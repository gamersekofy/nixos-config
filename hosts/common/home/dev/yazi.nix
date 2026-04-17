{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";
    extraPackages = [
      pkgs.glow
      pkgs.ouch
    ];

    flavors = {
      catppuccin-mocha = ./yazi-themes/catppuccin-mocha.yazi;
      catppuccin-latte = ./yazi-themes/catppuccin-latte.yazi;
    };

    theme = {
      flavor = {
        light = "catppuccin-latte";
        dark = "catppuccin-mocha";
      };
    };
  };

  programs.helix.settings = {
    keys.normal = {
      C-y = [
        ":sh rm -f /tmp/unique-ca1ea106"
        ":insert-output yazi \"%{buffer_name}\" --chooser-file=/tmp/unique-ca1ea106"
        ":sh printf \"\\x1b[?1049h\\x1b[?2004h\" > /dev/tty"
        ":open %sh{cat /tmp/unique-ca1ea106}"
        ":redraw"
        ":set mouse false"
        ":set mouse true"
      ];
    };
  };
}
