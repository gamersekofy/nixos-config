{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "catppuccin"
      "catppuccin-icons"
      "toml"
      "git-firefly"
      "latex"
      "crates-lsp"
    ];

    extraPackages = with pkgs; [
      nixd
      texlab
      crates-lsp
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

      show_edit_predictions = false;

      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = true;
        show_other_hints = true;
      };

      diagnostics = {
        inline.enabled = true;
      };

      ui_font_size = 16;
      buffer_font_size = 13.5;
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
