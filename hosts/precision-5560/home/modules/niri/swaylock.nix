{pkgs, ...}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
  };

  catppuccin.swaylock = {
    enable = true;
    flavor = "mocha";
  };
}
