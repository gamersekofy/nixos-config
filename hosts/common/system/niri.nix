{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.inputs.niri.nixosModules.niri
  ];
  programs.niri = {
    enable = true;
  };

  services.displayManager.sddm.package = pkgs.kdePackages.sddm;

  services.tumbler.enable = true;
}
