{
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "auto";
      };
    };

    clipboard.providers.wl-copy.enable = true;

    plugins = {
      web-devicons.enable = true;

      bufferline = {
        enable = true;
        settings = {
          options.hover = {
            enabled = true;
            delay = 200;
          };
        };
      };

      lualine = {
        enable = true;
      };

      neo-tree = {
        enable = true;
        enableDiagnostics = true;
        enableGitStatus = true;
        enableModifiedMarkers = true;
        enableRefreshOnWrite = true;
      };

      rustaceanvim.enable = true;

      which-key = {
        enable = true;
      };

      snacks = {
        enable = true;
      };
    };
  };
}
