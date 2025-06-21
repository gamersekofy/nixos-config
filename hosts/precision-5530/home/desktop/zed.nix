{pkgs, ...}: {
  xdg.desktopEntries.zed = {
    name = "Zed";
    genericName = "Text Editor";
    categories = ["Utility" "TextEditor" "Development" "IDE"];
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
      "New Workspace" = {
        exec = "DRI_PRIME=1 ${pkgs.zed-editor}/bin/zeditor --new %U";
      };
    };
  };
}
