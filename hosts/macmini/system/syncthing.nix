{
  services.syncthing = {
    enable = true;
    user = "uzair";
    dataDir = "/home/uzair/Documents/syncthing";
    configDir = "/home/uzair/Documents/syncthing/config";
    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = false;
  };
}
