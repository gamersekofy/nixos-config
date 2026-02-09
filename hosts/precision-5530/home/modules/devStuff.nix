{pkgs, ...}: {
  imports = [
    ./gamedev.nix
  ];
  home.packages = with pkgs; [
    # GUI code editors
    kdePackages.kate
    jetbrains.idea
    wireshark
  ];
}
