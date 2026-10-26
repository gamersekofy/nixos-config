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
        # bcrypt hash of the old GUI password; no plaintext in the Nix store.
        # Change it with: mkpasswd -m bcrypt '<new password>'
        password = "$2b$12$zXaVSGsA20SjWkgqxRvcnO8uQlIyIzOL76Ok/oMDgtkSCZkWTefGu";
      };
      devices = {
        "uzairPhone" = {id = "NA6LMLH-LWJ3L4L-PMVSSCH-BFUHRUU-B7TXBGU-746NUWZ-P5F5DFK-QJQM2QD";};
        # TODO after the macmini62 reinstall: replace with the new device ID
        # (`sudo -u uzair syncthing --device-id` on the macmini62) and rebuild
        # precision-5560. overrideDevices = true means GUI edits are reverted.
        "macMiniServer" = {id = "QC24M4F-TRQWXMF-NLRPLAI-LLELUIW-S7ISMPM-K5CPKX5-HSNUBEL-HIMNUAG";};
      };
      folders = {
        "Music" = {
          path = "/home/uzair/Music";
          devices = ["macMiniServer"];
        };
        "Secrets" = {
          path = "/home/uzair/Secrets";
          devices = ["macMiniServer" "uzairPhone"];
        };
        "Resumable" = {
          path = "/home/uzair/Pictures/.snap";
          devices = ["macMiniServer" "uzairPhone"];
        };
      };
    };
  };
}
