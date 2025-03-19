{
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services = {
    # Conflict with auto-cpufreq
    power-profiles-daemon.enable = false;
  };
}
