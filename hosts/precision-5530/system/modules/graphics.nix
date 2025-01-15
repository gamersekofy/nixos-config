{
  pkgs,
  lib,
  config,
  ...
}: {
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    #    extraPackages = with pkgs; [
    #      intel-media-sdk
    #      intel-ocl
    #      intel-compute-runtime
    #    ];
  };

  environment.systemPackages = with pkgs; [
    lshw
  ];
}
