{pkgs, ...}: {
  home.packages = with pkgs; [
    firefox-bin
    microsoft-edge
  ];

  # Enable Textfox TUI-style theme for Firefox
  textfox = {
    enable = true;
    profile = "uzair";
  };
}
