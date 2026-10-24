# macmini secrets (agenix)

Three encrypted files live here. They are empty placeholders right now, so the
build succeeds but activation refuses to start anything that needs them
(paperless, cloudflared, restic). Replace them before first real use.

## One-time setup, after NixOS has booted at least once

1. Get the host's age public key (on the macmini):

       ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub

   Put it in secrets.nix as the macmini recipient.

2. Install the agenix CLI on your workstation: nix shell nixpkgs#agenix

3. Encrypt each secret from the repo root, with an age identity you control
   (default ~/.config/age/keys.txt, or pass -i):

       agenix -e hosts/macmini/secrets/paperless-admin-password.age
       agenix -e hosts/macmini/secrets/restic-password.age
       agenix -e hosts/macmini/secrets/cloudflared-credentials.age

   Paperless: one line, the admin password.
   Restic: one line, a long random password. Store it in a password manager;
   without it the backups are unrecoverable.
   Cloudflared: the entire tunnel credentials JSON, unmodified.

4. Commit, then sudo nixos-rebuild switch.

## If the host key is ever regenerated

Re-encrypt all three, including the macmini recipient in secrets.nix, or
activation fails with a decryption error.
