{
  pkgs,
  inputs,
  ...
}: {
  programs.yazi.settings.opener.set-wallpaper = [
    {
      run = "${inputs.noctalia.packages.pkgs.stdenv.hostPlatform.system.default}/bin/noctalia-shell ipc call wallpaper set \"$1\" all";
      for = "linux";
      desc = "Set as wallpaper";
    }
  ];
}
