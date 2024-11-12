{pkgs, ...}: {
  users.users.uzair = {
    extraGroups = ["libvirtd"];
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
}
