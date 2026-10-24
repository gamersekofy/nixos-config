{...}: {
  # agenix. Decrypted at activation to /run/agenix/<name>.
  # Identity: the host's own /etc/ssh/ssh_host_ed25519_key (agenix default).
  # Encrypt with the commands in hosts/macmini/secrets/README.md.
  age.secrets = {
    paperless-admin-password = {
      file = ../secrets/paperless-admin-password.age;
      owner = "paperless";
      group = "paperless";
      mode = "0400";
    };

    restic-password = {
      file = ../secrets/restic-password.age;
      owner = "root";
      group = "root";
      mode = "0400";
    };

    cloudflared-credentials = {
      file = ../secrets/cloudflared-credentials.age;
      owner = "cloudflared";
      group = "cloudflared";
      mode = "0400";
    };
  };
}
