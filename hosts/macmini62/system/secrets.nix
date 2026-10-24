{...}: {
  # agenix. Decrypted at activation to /run/agenix/<name>.
  # Identity: the host's own /etc/ssh/ssh_host_ed25519_key (agenix default).
  # Encrypt with the commands in hosts/macmini62/secrets/README.md.
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

    # cloudflared runs as a DynamicUser and reads this through
    # LoadCredential, so it must be root-owned. A "cloudflared" owner does not
    # exist and makes the agenix chown step fail.
    cloudflared-credentials = {
      file = ../secrets/cloudflared-credentials.age;
      owner = "root";
      group = "root";
      mode = "0400";
    };

    syncthing-password = {
      file = ../secrets/syncthing-password.age;
      owner = "uzair";
      group = "users";
      mode = "0400";
    };

    # OpenClaw gateway bearer token. Injected as a SecretRef in openclaw.nix.
    openclaw-gateway-token = {
      file = ../secrets/openclaw-gateway-token.age;
      owner = "uzair";
      group = "users";
      mode = "0400";
    };

    # JSON document consumed by OpenClaw's file secret provider. Expected keys:
    # {"deepseek":"...","zai":"..."}
    openclaw-secrets = {
      file = ../secrets/openclaw-secrets.age;
      owner = "uzair";
      group = "users";
      mode = "0400";
    };

    # Plaintext env value for the gog file keyring.
    gog-keyring-password = {
      file = ../secrets/gog-keyring-password.age;
      owner = "uzair";
      group = "users";
      mode = "0400";
    };
  };
}
