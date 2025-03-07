{pkgs, inputs, ...}: {
   programs.niri = {
       enable = true;
   };

   environment.sessionVariables = {
    DISPLAY = ":0";
   };
}
