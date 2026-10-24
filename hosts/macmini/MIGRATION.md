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
