{pkgs, ...}: {
  programs.retroarch = {
    enable = true;
    cores = {
      sameboy = {
        enable = true;
      };
    };
  };
}
