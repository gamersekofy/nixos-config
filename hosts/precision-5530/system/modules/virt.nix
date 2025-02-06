{pkgs, ...}: {
  users.users.uzair = {
    extraGroups = ["libvirtd"];
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # VMWare
  environment.systemPackages = with pkgs; [
    vmware-workstation
  ];

  virtualisation.vmware.host.enable = true;

  # Docker
  virtualisation.docker = {
    enable = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };

    daemon.settings = {
      data-root = "/home/uzair/DockerData";
    };
  };
}
