{inputs, ...}: {
  imports = [inputs.nixcord.homeModules.nixcord];

  programs.nixcord = {
    enable = true;
    config = {
      themeLinks = ["https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/flavors/system24-rose-pine.theme.css"];
      plugins = {
        spotifyCrack = {
          enable = true;
          noSpotifyAutoPause = true;
        };

        streamerModeOnStream.enable = true;
        whoReacted.enable = true;
        voiceDownload.enable = true;
        silentTyping = {
          enable = true;
          showIcon = true;
          isEnabled = true;
        };
        silentMessageToggle = {
          enable = true;
          autoDisable = false;
        };
        showHiddenThings.enable = true;
        showHiddenChannels.enable = true;
        serverInfo.enable = true;
        reverseImageSearch.enable = true;
        fakeNitro.enable = true;
        readAllNotificationsButton.enable = true;
      };
    };
  };
}
