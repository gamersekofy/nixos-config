{
  services = {
    fprintd = {
      enable = true;
    };
    fwupd.enable = true;
  };

  hardware = {
    sensor.iio.enable = true;
    enableRedistributableFirmware = true;
  };
}
