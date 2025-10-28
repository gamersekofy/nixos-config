{pkgs, ...}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;

    # Tell file picker to ignore these files or directories
    ignores = [
      # Rust's target directory
      "target/"
      ".direnv/"
    ];

    languages = {
      # Enable Clippy on save
      language-server.rust-analyzer.config = {
        check = {command = "clippy";};
        cargo = {features = "all";};
      };

      language-server.nixd = {
        command = "${pkgs.nixd}/bin/nixd";
      };

      language-server.crates-lsp = {
        command = "${pkgs.crates-lsp}/bin/crates-lsp";
      };

      language = [
        {
          name = "nix";
          formatter.command = "alejandra";
          language-servers = ["nixd"];
        }

        {
          name = "toml";
          language-servers = ["crates-lsp"];
        }
      ];
    };

    themes = {
      catppuccin_mocha = builtins.readFile ./helix-themes/catppuccin_mocha.toml;
    };

    settings = {
      theme = "catppuccin_mocha";

      editor = {
        end-of-line-diagnostics = "error";

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        indent-guides = {
          render = true;
          character = "┊";
        };

        inline-diagnostics = {
          cursor-line = "warning";
          other-lines = "error";
        };

        # Tell file picker to show hidden files and directories
        file-picker.hidden = false;

        # Tweak bottom status bar
        statusline = {
          left = ["mode" "spinner" "file-name" "read-only-indicator" "file-modification-indicator" "version-control"];
          right = ["diagnostics" "selections" "register" "position" "position-percentage" "file-encoding" "file-line-ending" "file-type"];
        };

        whitespace = {
          render = "all";
          characters = {
            space = " ";
            npsb = "⍽";
            nnbsp = "␣";
            tab = "→";
            newline = "⏎";
            tabpad = "·";
          };
        };

        lsp.display-inlay-hints = true;
      };
    };
  };
}
