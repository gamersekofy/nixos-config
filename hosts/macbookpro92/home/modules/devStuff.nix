{pkgs, ...}: {
  home.packages = with pkgs; [
    # GUI code editors
    kdePackages.kate
    (jetbrains.plugins.addPlugins jetbrains.rider ["github-copilot"])
  ];
}
