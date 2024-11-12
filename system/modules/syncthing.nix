{pkgs, ...}: {
  # Enable and set up Syncthing
  services.syncthing = {
    enable = true;
    user = "uzair";
    dataDir = "/home/uzair/Documents/syncthing";
    configDir = "/home/uzair/Documents/syncthing/config";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      gui = {
        user = "uzair";
        password = "welcome@123";
      };
      devices = {
        "uzairPhone" = {id = "NA6LMLH-LWJ3L4L-PMVSSCH-BFUHRUU-B7TXBGU-746NUWZ-P5F5DFK-QJQM2QD";};
        "macMiniServer" = {id = "QC24M4F-TRQWXMF-NLRPLAI-LLELUIW-S7ISMPM-K5CPKX5-HSNUBEL-HIMNUAG";};
      };
      folders = {
        "Music" = {
          path = "/home/uzair/Music";
          devices = ["macMiniServer"];
        };
        "Secrets" = {
          path = "/home/uzair/shhSecret";
          devices = ["macMiniServer"];
        };
      };
    };
  };
}
