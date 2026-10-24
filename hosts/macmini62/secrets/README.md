# macmini62 secrets (agenix)

Seven age-encrypted files, one per consumer. Every `.age` file in this
directory is currently a 0-byte placeholder, committed so the flake evaluates
before the host exists. Replace each one before the first real switch.

## How it works

- At activation the host decrypts each file with its own SSH host key
  (`/etc/ssh/ssh_host_ed25519_key`, agenix's default identity) into
  `/run/agenix/<name>`. The plaintext never touches the store or the disk.
- You edit and re-encrypt from precision-5560 with your personal age key.
- Recipients live in `secrets.nix` in this directory, one entry per file.
  A file needs every key that must decrypt it: the macmini62 host key and your
  personal key.

## One-time: collect both public keys

Personal key, on precision-5560 (skip if `~/.config/age/keys.txt` exists):

~~~bash
nix shell nixpkgs#age -c age-keygen -o ~/.config/age/keys.txt
nix shell nixpkgs#age -c age-keygen -y ~/.config/age/keys.txt
~~~

Host key, on macmini62:

~~~bash
nix run nixpkgs#ssh-to-age -- < /etc/ssh/ssh_host_ed25519_key.pub
~~~

Put both in `secrets.nix`:

~~~nix
let
  macmini62 = "age1...";  # ssh-to-age output
  personal = "age1...";   # age-keygen -y output
in {
  "paperless-admin-password.age".publicKeys = [macmini62 personal];
  # ...one line per file
}
~~~

Without the personal key as a recipient you cannot create or edit secrets from
the laptop. Without the host key the macmini62 cannot decrypt them.

## Encrypt or edit a file

The CLI finds its rules file in the **current directory** (it looks for
`agenix-rules.nix`, then `secrets.nix`, and only searches parents for
`agenix-rules.nix`). Run it from this directory with bare filenames; running it
from the repo root fails with "agenix needs a rules file".

~~~bash
cd ~/Projects/nixos-config/hosts/macmini62/secrets
nix run github:ryantm/agenix -- -e paperless-admin-password.age \
  -i ~/.config/age/keys.txt
~~~

`nix shell nixpkgs#agenix -c agenix` does not work: nixpkgs has no `agenix`
attribute. Use the flake command above, or put agenix in a devshell.

The 0-byte placeholders cannot be decrypted, so either delete one before
editing or pipe the value in. Piped stdin replaces the file without decrypting
first, which is the scriptable path:

~~~bash
rm -f paperless-admin-password.age
printf '%s' "$PAPERLESS_ADMIN_PASSWORD" | \
  nix run github:ryantm/agenix -- -e paperless-admin-password.age \
  -i ~/.config/age/keys.txt
~~~

Verify with your personal key, which is the only identity available on the
laptop:

~~~bash
nix run github:ryantm/agenix -- -d paperless-admin-password.age \
  -i ~/.config/age/keys.txt
~~~

Do not use `agenix -c` as the gate: it only validates SSH-form recipients and
reports "cannot check non-SSH recipient" for `age1...` keys derived by
`ssh-to-age`.

## What each file must contain

| File | Contents | Owner / mode |
|---|---|---|
| `paperless-admin-password.age` | one line, the Paperless admin password | paperless:paperless 0400 |
| `restic-password.age` | one line, long random restic repository password | root:root 0400 |
| `cloudflared-credentials.age` | the tunnel credentials JSON, verbatim | root:root 0400 |
| `syncthing-password.age` | one line, the Syncthing GUI password in **plaintext** | uzair:users 0400 |
| `openclaw-gateway-token.age` | JSON: `{"gatewayToken":"..."}` | uzair:users 0400 |
| `openclaw-secrets.age` | JSON: `{"deepseek":"...","zai":"..."}` | uzair:users 0400 |
| `gog-keyring-password.age` | one line, the gog file-keyring password | uzair:users 0400 |

Notes:

- `syncthing-password` is plaintext. The NixOS module hashes it at runtime
  (`guiPasswordFile`). Do not paste a bcrypt hash here.
- `cloudflared-credentials` must be root-owned: cloudflared runs as a
  `DynamicUser` and reads the file through `LoadCredential`, so a
  "cloudflared" owner does not exist and the agenix chown fails.
- `openclaw-secrets` is a single JSON document. Each key must match the `id`
  used by a SecretRef in `hosts/macmini62/home/openclaw.nix` (`deepseek`,
  `zai`). Add a key there when you add a provider.
- `openclaw-gateway-token` must be JSON with a `gatewayToken` member; the
  gateway reads it with `id = "/gatewayToken"`.
- `restic-password` is the only way into the backup repository. Store it in a
  password manager. Losing it makes every snapshot unreadable.

## Ownership is declared, not assumed

`hosts/macmini62/system/secrets.nix` sets `owner`, `group` and `mode` for each
file. agenix applies them when it materialises `/run/agenix`. Keep the two
files in sync when you add a secret.

## Rotate a secret

1. Re-encrypt with `-e` as above.
2. Commit and switch: `sudo nixos-rebuild switch --flake .#macmini62`.
3. Restart the consumer: `systemctl restart paperless`, `systemctl restart
   cloudflared-tunnel-macmini62`, or `systemctl --user restart
   openclaw-gateway`.

## If the host key is regenerated

Re-encrypt all seven files and update the `macmini62` recipient in
`secrets.nix`. A missing recipient shows up as an agenix decryption failure at
activation, and the service that needs the file does not start.
