{pkgs, ...}: {
  users.users.uzair = {
    extraGroups = ["libvirtd"];
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  virtualisation = {
    # Docker
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };

      daemon.settings = {
        data-root = "/home/uzair/DockerData";
      };
    };

    # Run Android apps
    #waydroid.enable = true;
  };
}
