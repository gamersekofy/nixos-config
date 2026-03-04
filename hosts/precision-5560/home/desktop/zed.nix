{pkgs, ...}: {
  xdg.desktopEntries."dev.zed.Zed" = {
    name = "Zed";
    genericName = "Text Editor";
    categories = ["Development"];
    comment = "A high-performance, multiplayer code editor.";
    exec = "DRI_PRIME=1 zeditor %U";
    icon = "zed";
    mimeType = ["text/plain"];
    noDisplay = false;
    prefersNonDefaultGPU = true;
    startupNotify = true;
    terminal = false;
    type = "Application";
    actions = {
      "NewWorkspace" = {
        exec = "DRI_PRIME=1 ${pkgs.zed-editor}/bin/zeditor --new %U";
        name = "New Workspace";
      };
    };
  };
}
