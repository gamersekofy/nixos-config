{pkgs, ...}:{
  users.users.uzair = {
    isNormalUser = true;
    description = "Uzair Mohammed";
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  programs.fish.enable = true;
}
