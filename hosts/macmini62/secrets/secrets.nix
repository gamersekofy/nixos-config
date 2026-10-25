# agenix recipients. Fill macmini62 from:
#   ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub   (on the macmini62)
# Add your personal age public key so you can create and edit these files from
# the precision-5560. Generate one there with:
#   age-keygen -o ~/.config/age/keys.txt
# then put its public key here:
#   personal = "age1...";
let
  macmini62 = "age1wmkvx8vj9wu4qn082d49wsf56dd99qa05f78hehvje6uukkeqa7qpjxqxw";
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
