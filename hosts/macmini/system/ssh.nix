{
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.uzair.openssh.authorizedKeys.keys = [
    # TODO: paste the public key(s) you actually use (laptop, phone, etc.)
  ];
}
