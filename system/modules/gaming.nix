{pkgs, ... }: {
  programs.steam = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    heroic
    mangohud
    osu-lazer
  ];
}
