{pkgs, ...}: {
  imports = [
    ../../common/system/graphics.nix
  ];
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      intel-compute-runtime
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  boot.kernelParams = ["i915.enable_guc=3"];
}
