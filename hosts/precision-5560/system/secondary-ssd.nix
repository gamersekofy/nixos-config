{
  services.fstrim.enable = true;

  boot.initrd.luks.devices."komaniya_mapped" = {
    device = "/dev/disk/by-uuid/e641bdb0-913e-4c27-b2b2-b3e43497264b";
    allowDiscards = true;
  };

  fileSystems."/mnt/KomaniyaExpress" = {
    device = "/dev/mapper/komaniya_mapped";
    fsType = "btrfs";
    options = [
      "compress=zstd:1"
      "noatime"
      "discard=async"
    ];
  };
}
