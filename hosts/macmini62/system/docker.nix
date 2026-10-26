{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
    daemon.settings = {
      ipv6 = true;
      "fixed-cidr-v6" = "fd00::/64";
      experimental = true;
      ip6tables = true;
    };
  };

  systemd.services.docker.after = ["network-online.target"];
  systemd.services.docker.wants = ["network-online.target"];
}
