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
          "20" = "dark";
          "80" = "dim";
          "250" = "normal";
          "500" = "bright";
          "800" = "outdoors";
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

    keyboard = [
      {
        name = "keyboard-apple";
        path = "/sys/bus/platform/devices/applesmc.768/leds/smc::kbd_backlight";
      }
    ];
  };
}
