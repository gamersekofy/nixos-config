{
  # Override LM Studio entry to always launch with Wayland
  xdg.desktopEntries.lm-studio = {
    name = "LM Studio";
    exec = "lmstudio --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
    terminal = false;
    type = "Application";
    icon = "lm-studio";
    categories = [ "Utility" ];
    comment = "Discover, download, and run LLMs locally";
  };
}
