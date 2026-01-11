{
  imports = [
    ../../../common/home/wm-utils/wluma.nix
  ];

  services.wluma.settings = {
    als = {
      iio = {
        path = "/sys/bus/iio/devices";
        thresholds = {
          "0" = "night";
          "10" = "dark";
          "40" = "dim";
          "120" = "normal";
          "200" = "bright";
          "350" = "outdoors";
        };
      };
    };

    output.backlight = [
      {
        name = "LVDS-1";
        path = "/sys/class/backlight/intel_backlight";
        capturer = "none";
      }
    ];

    keyboard = [
      {
        name = "keyboard-apple";
        path = "/sys/bus/platform/devices/applesmc.768/leds/smc::kbd_backlight";
      }
    ];
  };
}
