{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts._3270
    nerd-fonts.departure-mono
    anakron

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
}
