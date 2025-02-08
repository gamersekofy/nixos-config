{
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services = {
    # Conflict with auto-cpufreq
    power-profiles-daemon.enable = false;

    # List of governors:
    #     - performance
    #     - powersave
    #     - userspace
    #     - ondemand
    #     - conservative
    #     - schedutil
    # cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
    # https://github.com/AdnanHodzic/auto-cpufreq/blob/v2.3.0/auto-cpufreq.conf-example

    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };

        charger = {
          governor = "performance";
          # always, auto, never
          turbo = "auto";
        };
      };
    };
  };
}
