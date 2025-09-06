{pkgs, ...}:{
  programs.zed-editor = {
    enable = true;
    extensions = ["nix" "catppuccin" "catppuccin-icons" "toml" "git-firefly" "latex"];

    extraPackages = with pkgs; [
      nixd
      texlab
    ];

    userSettings = {
      vim_mode = false;

      agent = {
        default_profile = "ask";
        default_model = {
          provider = "copilot_chat";
          model = "gemini-2.5-pro";
        };
      };

      ui_font_size = 16;
      buffer_font_size = 15;
      buffer_font_family = "JetBrainsMono Nerd Font";

      theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };

      icon_theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
    };
  };
}
