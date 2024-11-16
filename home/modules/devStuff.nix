{pkgs, ...}: {
  home.sessionVariables = {
    EDITOR = "hx";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    NIXOS_CONFIG = "/home/uzair/Documents/nixos-config";
  };

  programs.neovim = let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-cmp
      neoformat
      rustaceanvim
      telescope-fzf-native-nvim
      cmp_luasnip
      cmp-nvim-lsp
      luasnip
      friendly-snippets
      nvim-web-devicons
      vim-nix
      copilot-vim

      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./nvimPlugins/lsp.lua;
      }

      {
        plugin = comment-nvim;
        config = toLua "require(\"Comment\").setup()";
      }

      {
        plugin = catppuccin-nvim;
        config = "colorscheme catppuccin-mocha";
      }

      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvimPlugins/telescope.lua;
      }

      {
        plugin = nvim-cmp;
        config = toLuaFile ./nvimPlugins/cmp.lua;
      }

      {
        plugin = lualine-nvim;
        config = toLuaFile ./nvimPlugins/lualine.lua;
      }

      {
        plugin = trouble-nvim;
        #        config = toLuaFile ./nvimPlugins/trouble.lua;
      }

      {
        plugin = nvim-tree-lua;
        config = toLuaFile ./nvimPlugins/tree.lua;
      }

      {
        plugin = nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-json
          p.tree-sitter-yaml
          p.tree-sitter-typescript
          p.tree-sitter-toml
          p.tree-sitter-sql
          p.tree-sitter-rust
          p.tree-sitter-markdown
          p.tree-sitter-make
          p.tree-sitter-java
          p.tree-sitter-kotlin
          p.tree-sitter-html
          p.tree-sitter-fish
          p.tree-sitter-css
          p.tree-sitter-cpp
          p.tree-sitter-cmake
          p.tree-sitter-c-sharp
          p.tree-sitter-c
        ]);
        config = toLuaFile ./nvimPlugins/treesitter.lua;
      }
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./nvimPlugins/other.lua}
    '';

    extraPackages = with pkgs; [
      wl-clipboard
      ripgrep
    ];
  };

  programs.helix = {
    enable = true;
  };

  home.packages = with pkgs; [
    # GUI code editors
    kdePackages.kate
    vscode.fhs

    # Utilities
    wget
    unzip

    # IDE
    jetbrains.idea-ultimate
    jetbrains.rider

    # nix language server
    nixd

    # nix formatter
    alejandra

    # something for fish lol
    fasd
  ];
}
