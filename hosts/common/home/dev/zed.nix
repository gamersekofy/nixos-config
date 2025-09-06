{pkgs, ...}:{
  programs.zed-editor = {
    extensions = ["nix" "catppuccin" "catppuccin-icons"];

    extraPackages = with pkgs; [
      nixd
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
      buffer_font_family = "ANAKRON";

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
