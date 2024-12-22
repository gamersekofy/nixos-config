{
  pkgs,
  lib,
  config,
  ...
}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-sdk
      intel-ocl
      intel-compute-runtime
    ];
  };

  environment.systemPackages = with pkgs; [
    lshw
  ];

  specialisation = {
    gaming-mode.configuration = {
      system.nixos.tags = ["gaming-mode"];

      services.xserver.videoDrivers = ["nvidia"];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        prime = {
          intelBusId = lib.mkDefault "PCI:0:2:0";
          nvidiaBusId = lib.mkDefault "PCI:1:0:0";
        };
      };

      environment.systemPackages = [nvidia-offload];

      # Limit charging using TLP. Also turn off auto-cpufreq to avoid conflict
      services.auto-cpufreq.enable = lib.mkForce false;
      services.tlp = {
        enable = true;
        settings = {
          START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
          STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
        };
      };
    };
  };
}
