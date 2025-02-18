{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nixcord.homeManagerModules.nixcord];

  home.packages = with pkgs; [
    zoom-us
    thunderbird
    element-desktop
    telegram-desktop
  ];

  programs.nixcord = {
    enable = true;
    config = {
      themeLinks = [ "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/flavors/catppuccin-mocha.theme.css" ];
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
