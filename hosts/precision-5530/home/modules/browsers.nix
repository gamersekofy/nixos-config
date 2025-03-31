{pkgs, ...}: {
  home.packages = with pkgs; [
    microsoft-edge
  ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [pkgs.kdePackages.plasma-browser-integration];
  };
}
