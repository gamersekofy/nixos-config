{pkgs, ...}: {
  imports = [
    ../../common/system/graphics.nix
  ];

  hardware.graphics = {
    enable32Bit = true;

    extraPackages = with pkgs; [
      intel-vaapi-driver
      intel-ocl
    ];
  };
}
