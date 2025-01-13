# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/937e3ce3-554d-4249-b1b0-1d4c0dcf568c";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-1335075f-fce0-4057-964d-b30cca308aef".device = "/dev/disk/by-uuid/1335075f-fce0-4057-964d-b30cca308aef";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0C95-0FAD";                                                                                                                                                                    
      fsType = "vfat";                                                                                                                                                                                           
      options = [ "fmask=0077" "dmask=0077" ];                                                                                                                                                                   
    };                                                                                                                                                                                                           
                                                                                                                                                                                                                 
  swapDevices =                                                                                                                                                                                                  
    [ { device = "/dev/disk/by-uuid/23c2d8c2-21f7-4c92-be68-23eb2f689e30"; }                                                                                                                                     
    ];                                                                                                                                                                                                           
                                                                                                                                                                                                                 
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking                                                                                                                         
  # (the default) this is the recommended approach. When using systemd-networkd it's                                                                                                                             
  # still possible to use this option, but it's recommended to use it in conjunction                                                                                                                             
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.                                                                                                                   
  networking.useDHCP = lib.mkDefault true;                                                                                                                                                                       
  # networking.interfaces.wlp59s0.useDHCP = lib.mkDefault true;                                                                                                                                                  
                                                                                                                                                                                                                 
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";                                                                                                                                                           
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;                                                                                                              
}
