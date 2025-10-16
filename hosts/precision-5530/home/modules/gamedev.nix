{pkgs, ...} :{
  home.packages = with pkgs; [
    unityhub
    jetbrains.rider
  ];
}
