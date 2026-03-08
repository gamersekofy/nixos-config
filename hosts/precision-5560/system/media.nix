{config, ...}: {
  # To enable the OBS Virtual Camera
  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
  boot.kernelModules = [
    "v4l2loopback"
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    options xe force_probe=9a60
    options i915 force_probe=!9a60
  '';
  security.polkit.enable = true;
}
