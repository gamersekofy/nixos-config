{
  # Override LM Studio entry to always launch with Wayland
  xdg.desktopEntries.lmstudio = {
    name = "LM Studio";
    exec = "lmstudio --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
    icon = "./icons/lmstudio.png";
  };
}
