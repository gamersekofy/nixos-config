{
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      # Flip this to false only after you have confirmed key login works.
      # The box is headless; a key mistake means physical console recovery.
      PasswordAuthentication = true;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.uzair.openssh.authorizedKeys.keys = [
    # YubiKey, github-auth slot (resident credential, requires touch)
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHSWKFa37dMtV7XyDw//ntlTEUgmZnkay3hm+hXDSpApAAAAD3NzaDpnaXRodWItYXV0aA== ssh:github-auth"
    # YubiKey, git-signing slot (resident credential, requires touch)
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICV8xaw0idrjzIb/SjSWTdND6IHbyfL0uMS1lb0BdBXCAAAAD3NzaDpnaXQtc2lnbmluZw== YubiKey Git Signing Key"
    # Ineffa (OpenClaw) on the gateway. Remove if you do not want agent access.
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARuYOZsrpd6cKqgjUZMijCn4XrMU3q8b6ohybvy8s/6 openclaw@macmini"
  ];
}
