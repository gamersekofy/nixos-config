# macmini -> NixOS: backup and restore guide

Generated 2026-10-23 for the Late 2012 Mac mini (i5-3210M, 16 GB, 1 TB SSD).
Only five services survive: Home Assistant, Gitea, Paperless, Syncthing,
Minecraft. Pingvin, Slash and Passbolt are retired.

Data that must survive: **Gitea, Minecraft, Paperless.**
Syncthing and Home Assistant data are disposable.

---

## 1. Gitea

~~~bash
cd ~/Documents/Gitea
docker compose stop gitea
docker exec gitea-db-1 pg_dumpall -U gitea > ~/backup/gitea.sql
sudo tar czf ~/backup/gitea-data.tar.gz -C ~/Documents/Gitea gitea
cp docker-compose.yaml ~/backup/gitea-compose.yaml
docker compose start gitea
~~~

Restore: create the database/role (the NixOS module does it), load gitea.sql,
untar into /var/lib/gitea, then

~~~bash
sudo chown -R git:git /var/lib/gitea
~~~

The container used uid 1000; NixOS uses the git user. Ownership is the usual
failure here.

## 2. Paperless

~~~bash
cd ~/Documents/paperless-ngx
docker compose stop
docker exec paperless-db-1 pg_dump -U paperless paperless > ~/backup/paperless.sql
sudo tar czf ~/backup/paperless-files.tar.gz data media consume export
cp docker-compose.yml ~/backup/paperless-compose.yml
docker compose start
~~~

Do not copy the PostgreSQL 13 data directory: the new module is PostgreSQL 16.
Dump and restore.

New paths: /var/lib/paperless/{data,media,consume}. The Samba share named
"scans" points at consume.

## 3. Minecraft — already copied

Restore ~/Documents/minecraft-server to /srv/minecraft with the same layout
(data, mods, plugins, config).

## 4. Nginx and certificates (reference)

- /etc/nginx (especially sites-available/uzair.page)
- /etc/letsencrypt (certs, keys, renewal/*.conf)
- The renewal files reveal HTTP-01 vs DNS-01 and, if DNS-01, where the
  Cloudflare API token lives — that is the Cloudflare config you forgot.
- Note DNS proxy status per hostname: casa/git/docs/syncthing are orange-cloud.

nginx.nix ships port 80 vhosts only. Pick Cloudflare Tunnel (recommended) or
security.acme with DNS-01.

## 5. OpenClaw

~~~bash
systemctl --user stop openclaw-gateway
mkdir -p ~/backup/openclaw
sqlite3 ~/.openclaw/state/openclaw.sqlite ".backup $HOME/backup/openclaw/openclaw.sqlite"
cp ~/.openclaw/openclaw.json ~/backup/openclaw/
cp -a ~/.openclaw/media ~/backup/openclaw/media
systemctl --user start openclaw-gateway
~~~

Workspaces and learned skills are already committed in the three git repos.
Skip cache, tmp, browser, npm.

## 6. System odds and ends

- /etc/docker/daemon.json
- /etc/hosts, /etc/fstab
- /etc/ssh/ssh_host_* (optional)
- /var/lib/tailscale (optional; otherwise re-auth)
- dpkg --get-selections > ~/backup/packages.txt
- Router port-forward table and Cloudflare DNS records

## 7. Restore order

1. Base system, tailscale, ssh.
2. nixos-rebuild switch --flake .#macmini, fix hardware-configuration.nix.
3. Gitea (DB, then data), verify a clone.
4. Paperless (DB, then files), verify a scan.
5. Minecraft, verify the world before opening the port.
6. Syncthing, re-pair laptops (server device ID changes).
7. Home Assistant.
8. OpenClaw, then gog + Todoist auth, then devices.

## 8. Gotchas

- Apple EFI: GRUB removable, no EFI variable writes.
- Gitea ownership: chown -R git:git.
- Paperless: PG13 -> PG16 means dump/restore.
- Samba: printer must speak SMB2; share is guest-writable, forced to paperless.
- Syncthing: openDefaultPorts = false (tailnet only).
- nix-openclaw sets OPENCLAW_NIX_MODE=1: openclaw plugins install fails by design.

---

# Addendum: headless host, tunnel, secrets

## 9. Headless is fine

No desktop is needed. Nothing in this config pulls X or Wayland:

- OpenClaw drives headless Chromium through Playwright. No X server involved.
- Typst, ffmpeg, poppler-utils, ripgrep, yazi, bat, atuin, eza are all CLI.
- services.xserver.xkb (from the shared tzLocale module) only sets a keymap.
  It does not enable a display server.

The one workflow that expects a browser is gog auth. On a tty use
"gog auth --manual" and paste the code, or forward a port over SSH.

### Keyring / wallet

There is no KDE Wallet or GNOME Keyring, so anything that calls libsecret
fails. That is acceptable here because nothing on the box needs it:

- git: SSH keys, not a credential helper.
- restic: password file from agenix.
- gog: its own file keyring (needs GOG_KEYRING_PASSWORD as an env secret).
- OpenClaw: provider auth lives in its own config.

If you later want libsecret, gnome-keyring can run under a tty, but a keyring
unlocked by a login password is useless over pubkey-only SSH. Prefer files.

### Shell over SSH

users.users.uzair.shell = pkgs.fish, so an SSH session lands in fish directly.
The shared fish, starship, eza, atuin, yazi, bat, direnv and nix-index modules
are imported, so yazi, ctrl-r history search and the z plugin behave like the
5560. One deliberate difference: the shared fish module aliases gc to
"git commit -S", which needs a YubiKey. This host forces "git commit -m".

## 10. Secrets (agenix)

Three secret files live under hosts/macmini/secrets/. They are empty
placeholders, so the build works but paperless, cloudflared and restic will
fail to start until they are encrypted. That failure is intentional.

Order matters, because agenix encrypts to the host's SSH key, which does not
exist until the host has booted once.

1. Install and boot NixOS. sshd generates /etc/ssh/ssh_host_ed25519_key.
   Paperless, cloudflared and restic will be red. Expected.
2. On the macmini:  ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
   Put that age1... value into hosts/macmini/secrets/secrets.nix as macmini.
3. From a workstation with the repo checked out and agenix available:

       agenix -e hosts/macmini/secrets/paperless-admin-password.age
       agenix -e hosts/macmini/secrets/restic-password.age
       agenix -e hosts/macmini/secrets/cloudflared-credentials.age

   paperless: one line, the admin password.
   restic: one line, a long random password. Save it in a password manager.
           Without it the repository cannot be restored.
   cloudflared: the tunnel credentials JSON verbatim.
4. Commit and run nixos-rebuild switch.

Agenix decrypts to /run/agenix/<name> with the owner and mode set in
hosts/macmini/system/secrets.nix, so no service reads a root-owned file as
its own user.

## 11. Restic to the precision-5560

backup.nix backs up to sftp:uzair@precision-5560:/home/uzair/backups/macmini
(the directory already exists on the 5560). Restic runs as root, so root needs
a key that the 5560 accepts:

    sudo ssh-keygen -t ed25519 -N "" -C macmini-restic -f /root/.ssh/id_ed25519
    sudo cat /root/.ssh/id_ed25519.pub

Append that line to uzair@precision-5560:~/.ssh/authorized_keys, then:

    sudo systemctl start restic-backups-macmini.service
    sudo journalctl -u restic-backups-macmini -n 40

The restic password is the agenix secret from section 10.

## 12. Cloudflare Tunnel (chosen over nginx)

nginx is gone. There are no inbound web ports, no certificates to renew, and
no port forwarding. cloudflared dials out to Cloudflare and proxies each
hostname to loopback:

    casa.uzair.page      -> 127.0.0.1:8123   (Home Assistant)
    docs.uzair.page      -> 127.0.0.1:28981  (Paperless)
    git.uzair.page       -> 127.0.0.1:3000   (Gitea)
    syncthing.uzair.page -> 127.0.0.1:8384   (Syncthing)

Setup, in the Cloudflare dashboard (zone uzair.page):

1. Zero Trust -> Networks -> Tunnels -> Create a tunnel -> Cloudflared.
   Name it macmini. Copy the connector token if asked, but use the
   credentials JSON instead: the tunnel's "Download credentials" file.
2. Public hostnames: add the four above, each with service
   http://127.0.0.1:<port>. Cloudflare creates the proxied CNAMEs itself.
3. Put the credentials JSON into the cloudflared-credentials agenix secret.
4. Rebuild. Check with: systemctl status cloudflared-tunnel-macmini
   and: journalctl -u cloudflared-tunnel-macmini -n 50
5. Confirm each hostname resolves through Cloudflare and not to your WAN IP.

Old hostnames and their DNS records: leave the A/AAAA records in place until
the tunnel works, then delete them so nothing points at the router.

### Paperless behind a proxy

PAPERLESS_URL is https://docs.uzair.page and PAPERLESS_TRUSTED_PROXIES is
127.0.0.1. If Django rejects the admin login with a CSRF error, add the origin:

    PAPERLESS_CSRF_TRUSTED_ORIGINS = "https://docs.uzair.page";

### Things that still need a port

Only these stay open in the firewall: 22 (ssh), 2222 (Gitea ssh),
8123 (Home Assistant, used on the LAN by phones), 25565 (Minecraft).
Web UIs are loopback-only and reachable through the tunnel or over Tailscale.

## 13. systemd-boot on the Mac mini

Use systemd-boot, not GRUB. Keep canTouchEfiVariables = false; bootctl writes
the removable fallback to EFI/BOOT/BOOTX64.EFI, which Apple firmware boots
without NVRAM entries. If the mini shows a blank screen, that fallback path is
the first thing to check.
