{pkgs, ...}: {
  imports = [
    ./gamedev.nix
  ];
  home.packages = with pkgs; [
    # GUI code editors
    kdePackages.kate
    vscode.fhs
    jetbrains.idea-ultimate
  ];
}
