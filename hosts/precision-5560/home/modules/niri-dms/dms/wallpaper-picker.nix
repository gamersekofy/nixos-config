{
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  noctalia-pkg = inputs.noctalia.packages.${system}.default;
in {
  programs.yazi = {
    settings = {
      opener = {
        set-wallpaper = [
          {
            run = "${noctalia-pkg}/bin/noctalia-shell ipc call wallpaper set \"$1\" all";
            for = "linux";
            desc = "Set as Noctalia wallpaper";
          }
        ];
      };

      open = {
        prepend_rules = [
          {
            mime = "image/*";
            use = ["set-wallpaper" "open"];
          }
        ];
      };
    };
  };
}
