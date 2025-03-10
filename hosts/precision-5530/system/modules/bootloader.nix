{pkgs, ...}: {
  # Disable systemd boot to enable Grub
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Copied from default configuration file
  boot.initrd.luks.devices."luks-668849b8-3d8e-4c15-aac9-181206dceb64".device = "/dev/disk/by-uuid/668849b8-3d8e-4c15-aac9-181206dceb64";

  # GRUB and MC theme disabled due to an issue - "nixos.png not found"
  # Enable Grub and set required parameters to make system bootable
  boot.loader.grub = {
    enable = false;
    #  efiSupport = true;
    #  device = "nodev";
    #
    #  # This does not work for some reason
    #  gfxmodeEfi = "1920x1080";
    #  gfxmodeBios = "1920x1080";
    #
    #  # Enable the Minecraft world selection screen theme
    #  minegrub-world-sel = {
    #    enable = true;
    #    customIcons = [
    #      {
    #        name = "nixos";
    #        lineTop = "NixOS Vicuna (24/11/2024, 1:23)";
    #        lineBottom = "Survival Mode, No Cheats, Version: 24.11";
    #        # Icon: you can use an icon from the remote repo, or load from a local file
    #        imgName = "nixLogo";
    #        customImg = builtins.path {
    #           path = ./nixLogo.png;
    #           name = "nixLogo";
    #         };
    #      }
    #    ];
    #  };
  };
}
