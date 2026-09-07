{pkgs, ...}: {
  programs.qalculate = {
    enable = true;
    package = pkgs.qalculate-qt;
  };
}
