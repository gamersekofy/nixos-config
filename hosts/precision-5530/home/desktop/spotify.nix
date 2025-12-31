{
  # Override Spotify entry to always launch with Wayland
  xdg.desktopEntries.spotify = {
    name = "Spotify";
    genericName = "Music Player";
    icon = "spotify-client";
    exec = "spotify --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
    terminal = false;
    mimeType = ["x-scheme-handler/spotify"];
    categories = ["Audio" "Music" "Player" "AudioVideo"];
  };
}
