{lib, ...}: {
  powerManagement = {
    enable = true;
  };

  services = {
    power-profiles-daemon.enable = true;
    tlp.enable = lib.mkForce false;
    thermald.enable = true;
  };
}
