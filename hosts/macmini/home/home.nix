{pkgs, ...}: {
  imports = [./openclaw.nix];

  home.username = "uzair";
  home.homeDirectory = "/home/uzair";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Uzair Mohammed";
    userEmail = "uzair.hamed@gmail.com";
  };

  home.packages = with pkgs; [
    gogcli
    ripgrep
    jq
    ffmpeg
    poppler_utils
  ];
}
