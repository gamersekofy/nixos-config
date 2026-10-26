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

    carlito
    vista-fonts

    # Headless Chromium renders its own font fallback chain. Without these,
    # screenshots come back as tofu boxes with no error in any log.
    dejavu_fonts
    noto-fonts-color-emoji
  ];
}
