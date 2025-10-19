{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-sdk
      intel-ocl
      intel-compute-runtime
    ];
  };
}
