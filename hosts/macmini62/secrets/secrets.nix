# agenix recipients. Use the host's SSH public key directly, not its
# ssh-to-age conversion: agenix decrypts with the SSH private key, and age's
# SSH identity is not the same as the X25519 identity derived by ssh-to-age.
# On macmini62:
#   cat /etc/ssh/ssh_host_ed25519_key.pub
# Add your personal age public key so you can create and edit these files from
# the precision-5560. Generate one there with:
#   age-keygen -o ~/.config/age/keys.txt
# then put its public key here:
#   personal = "age1...";
let
  macmini62 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDthGkwOPsegmpAemOx9txY/O49tcTYQHcv1WvZ6r4iO root@nixos";
  personal = "age100xcjd8xmjmxawmkjqju64u63wn376hr7kytaa5s6exch48tadqsvk2trv";
in {
  "paperless-admin-password.age".publicKeys = [
    macmini62
    personal
  ];
  "restic-password.age".publicKeys = [
    macmini62
    personal
  ];
  "cloudflared-credentials.age".publicKeys = [
    macmini62
    personal
  ];
  "syncthing-password.age".publicKeys = [
    macmini62
    personal
  ];
  "openclaw-gateway-token.age".publicKeys = [
    macmini62
    personal
  ];
  "openclaw-secrets.age".publicKeys = [
    macmini62
    personal
  ];
  "gog-keyring-password.age".publicKeys = [
    macmini62
    personal
  ];
}
