{
  imports = [
    ../../../../common/home/wm-utils/wluma.nix
  ];

  services.wluma.settings = {
    als = {
      iio = {
        path = "/sys/bus/iio/devices";
        thresholds = {
          "0" = "night"; # Pitch black room
          "15" = "dark"; # Low mood lighting
          "60" = "dim"; # Living room at night
          "150" = "indoor"; # Typical home office (warm light)
          "350" = "office"; # Well-lit workspace / daylight near window
          "600" = "bright"; # Very bright indoor / indirect sunlight
          "1000" = "outdoors"; # Direct sunlight (Max backlight)
        };
      };
    };

    output.backlight = [
      {
        name = "eDP-1";
        path = "/sys/class/backlight/intel_backlight";
        capturer = "none";
      }
    ];
  };
}
