{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kmod
  ];
}
