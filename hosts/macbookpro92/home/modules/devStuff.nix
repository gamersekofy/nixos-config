{pkgs, ...}: {
  home.packages = with pkgs; [
    # GUI code editors
    kdePackages.kate
    wireshark
  ];
}
