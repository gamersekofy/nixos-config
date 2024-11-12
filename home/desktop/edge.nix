{
  # Override Edge entry to always launch with Wayland
  xdg.desktopEntries.microsoft-edge = {
    name = "Microsoft Edge";
    genericName = "Web Browser";
    exec = "microsoft-edge --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
    categories = [ "Network" "WebBrowser" ];
    mimeType = ["application/pdf" "application/rdf+xml" "application/rss+xml" "application/xhtml+xml" "application/xhtml_xml" "application/xml" "image/gif" "image/jpeg" "image/png" "image/webp" "text/html" "text/xml" "x-scheme-handler/http" "x-scheme-handler/https"];
    icon = "microsoft-edge";
  };
}
