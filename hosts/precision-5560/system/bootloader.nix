{pkgs, ...}: {
  # Disable systemd boot to enable Grub
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Copied from default configuration file
  boot.initrd.luks.devices."luks-02460964-8051-4381-aeae-a2b71a2c2f2d".device = "/dev/disk/by-uuid/02460964-8051-4381-aeae-a2b71a2c2f2d";

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
