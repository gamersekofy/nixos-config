{
  # Disable X11
  services.xserver.enable = false;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
