# agenix recipients. Fill macmini from:
#   ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub   (on the macmini)
# Optionally add a personal age key so you can re-encrypt from a laptop.
let
  macmini = "age1REPLACE_WITH_MACMINI_HOST_KEY";
in {
  "paperless-admin-password.age".publicKeys = [macmini];
  "restic-password.age".publicKeys = [macmini];
  "cloudflared-credentials.age".publicKeys = [macmini];
}
