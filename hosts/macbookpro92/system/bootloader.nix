{pkgs, ...}:{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-2865b079-da67-49e7-9b78-ba910d8a62b2".device = "/dev/disk/by-uuid/2865b079-da67-49e7-9b78-ba910d8a62b2";
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
