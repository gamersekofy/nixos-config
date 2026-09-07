{pkgs, ...}: {
  programs.gpu-screen-recorder = {
    enable = true;
    ui.enable = true;
  };

  environment.systemPackages = [
    pkgs.gpu-screen-recorder
    pkgs.gpu-screen-recorder-gtk
  ];
}
