{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.niri.nixosModules.niri
  ];
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  services.displayManager.sddm.package = pkgs.kdePackages.sddm;

  services.tumbler.enable = true;
  services.udisks2.enable = true;
}
