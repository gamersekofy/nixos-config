{pkgs, ...}: {
  programs.kde-pim = {
    enable = true;
    merkuro = true;
  };

  environment.systemPackages = with pkgs; [
    kdePackages.kdepim-runtime
    kdePackages.kdepim-runtime
    kdePackages.akonadi
  ];
}
