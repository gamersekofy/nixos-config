{
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      # Leave this true until key login is proven on the console.
      # The box is headless; a key mistake means physical recovery.
      PasswordAuthentication = true;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.uzair.openssh.authorizedKeys.keys = [
    # Public keys only. The private half (or the YubiKey) stays on the client.
    #
    # Login key, created on the precision-5560:
    #   ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_macmini62 -C uzair@precision-5560
    #
    # A YubiKey credential belongs here as a second entry, for daily use. It
    # must be a resident credential using the default application: OpenSSH
    # discovers resident credentials under "ssh:", so the existing
    # ssh:github-auth and ssh:git-signing credentials are not offered for host
    # authentication.
    #   ssh-keygen -t ed25519-sk -O resident -O application=ssh: \
    #     -f ~/.ssh/id_ed25519_sk_macmini62
    #
    # Keep a file key as the break-glass entry. A resident credential cannot be
    # exported, so a lost YubiKey would otherwise lock you out of a headless
    # host.
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYjy9VSC+zu3PzaRAEPZ9eCVOfmlsOrhEZHwKNxBRJf uzair@precision-5560"
  ];
}
