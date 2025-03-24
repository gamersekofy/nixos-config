{lib, ...}:{
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services = {
    power-profiles-daemon.enable = true;
    tlp.enable = lib.mkForce false;
  };
}
