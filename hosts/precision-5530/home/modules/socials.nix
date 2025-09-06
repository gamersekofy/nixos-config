{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    zoom-us
    thunderbird
    element-desktop
    telegram-desktop
  ];
}
