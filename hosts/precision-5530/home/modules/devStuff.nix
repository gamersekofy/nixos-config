{pkgs, ...}: {
  home.packages = with pkgs; [
    # GUI code editors
    kdePackages.kate
    jetbrains.idea

    wireshark
  ];
}
