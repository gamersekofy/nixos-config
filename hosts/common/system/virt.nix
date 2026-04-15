{pkgs, ...}: {
  users.users.uzair = {
    extraGroups = ["libvirtd"];
  };

  programs.virt-manager.enable = true;

  virtualisation = {
    # Libvirt
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };

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
