{
  networking.hostName = "macmini62";
  networking.networkmanager.enable = true;

  # Home Assistant discovery and printer browsing.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    settings = {
      publish = {
        "disable-publishing" = false;
        publish-addresses = true;
        publish-workstation = true;
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      8123
      25565
      2222
    ];
  };
}
