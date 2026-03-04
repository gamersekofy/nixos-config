{pkgs, ...}: {
  # Disable systemd boot to enable Grub
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Copied from default configuration file
  boot.initrd.luks.devices."luks-936e258e-37a4-4903-b6d0-d7646b840d74".device = "/dev/disk/by-uuid/936e258e-37a4-4903-b6d0-d7646b840d74";

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
