{pkgs, inputs, ...}: {
   programs.niri = {
       enable = true;
   };

   services.tumbler.enable = true;
}
