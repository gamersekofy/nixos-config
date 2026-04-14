{
  lib,
  pkgs,
  ...
}: {
  programs.ghostty.settings.theme = lib.mkForce "noctalia";

  programs.yazi.theme.flavor = {
    light = lib.mkForce "noctalia";
    dark = lib.mkForce "noctalia";
  };

  xdg.configFile."yazi/theme.toml".force = true;

  programs.helix.settings.theme = lib.mkForce "noctalia";

  programs.zed-editor.userSettings.theme = {
    light = lib.mkForce "Noctalia Light";
    dark = lib.mkForce "Noctalia Dark";
  };

  programs.firefox.nativeMessagingHosts = [pkgs.pywalfox-native];

  home.packages = [
    pkgs.pywalfox-native
    pkgs.adw-gtk3
  ];
}
