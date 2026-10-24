{
  system.stateVersion = "26.11";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "uzair"];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;
}
