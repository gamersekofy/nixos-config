{pkgs, ...}: {
  users.users.uzair = {
    isNormalUser = true;
    description = "Uzair Mohammed";
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel" "docker" "wireshark" "dialout"];
  };

  programs.fish.enable = true;
}
