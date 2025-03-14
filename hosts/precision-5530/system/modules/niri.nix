{pkgs, inputs, ...}: {
   programs.niri = {
       enable = true;
   };

   services.displayManager.sddm.package = pkgs.kdePackages.sddm;

   services.tumbler.enable = true;
}
