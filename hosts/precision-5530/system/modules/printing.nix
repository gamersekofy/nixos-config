{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = [pkgs.hplip pkgs.hplipWithPlugin];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
