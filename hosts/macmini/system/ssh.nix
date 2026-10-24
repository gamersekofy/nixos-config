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
    # From the precision-5560, create a normal key for server login:
    #   ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_macmini -C uzair@precision-5560
    # and paste ~/.ssh/id_ed25519_macmini.pub below.
    #
    # For YubiKey login, the resident credential must use the default
    # application "ssh:". Keys scoped to ssh:github-auth or ssh:git-signing
    # are not offered by the client for host authentication:
    #   ssh-keygen -t ed25519-sk -O resident -O application=ssh: \
    #     -f ~/.ssh/id_ed25519_sk_macmini
  ];
}
