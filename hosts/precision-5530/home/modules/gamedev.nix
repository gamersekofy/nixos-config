{pkgs, ...}: {
  home.packages = with pkgs; [
    unityhub
    # (jetbrains.plugins.addPlugins jetbrains.rider ["github-copilot-intellij-agent"])
    jetbrains.rider
  ];
}
