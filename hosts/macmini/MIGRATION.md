# macmini: Ubuntu to NixOS, start to finish

This is the offline runbook. It begins the moment the NixOS installer has
finished writing the system and asks you to reboot. Everything before that
point is Appendix A.

Current hardware facts, verified on the running Ubuntu system:

- The Ubuntu install lives entirely on the old HDD: /dev/sda, 465.8 GB,
  sda1 = /boot/efi (512 MB vfat), sda2 = / (ext4, 110 GB used). No LUKS.
- The target is the 1 TB Samsung EVO SSD. It is not currently visible to
  Ubuntu, so it is either not connected or not detected yet.
- Hostname today: uzair-Macmini. Tailscale name: uzair-macmini, 100.95.56.35.
- RAM 16 GB. No swap configured on Ubuntu.

STOP, READ THIS FIRST

Do not let the installer touch /dev/sda. The old HDD is your rollback: it
still has a working Ubuntu with all services. The safest sequence is to
unplug the HDD's SATA cable, install onto the SSD alone, then reconnect the
HDD afterwards. If you leave both connected, verify the target disk by size
(1 TB vs 465 GB) before you accept the partition plan.

Everything below assumes the installer has completed and the machine has
rebooted into the new NixOS system.

---

## 1. First boot

Log in on the console as uzair. The installer copies the config you gave it,
so if you installed with a minimal configuration you land in a bare shell.

1.1 Set a password (needed for sudo and for console recovery):

~~~bash
sudo passwd uzair
~~~

1.2 Confirm the network. Ethernet on a 2012 Mac mini is enp1s0f0 or similar:

~~~bash
ip -brief addr
nmcli device status
ping -c 2 1.1.1.1
~~~

If the link is down:

~~~bash
sudo nmcli device connect <ifname>
sudo nmcli connection show
~~~

1.3 Enable flakes for this session. The repo's nix-settings.nix turns them on
permanently, but the first switch happens before that file is active:

~~~bash
export NIX_CONFIG='experimental-features = nix-command flakes'
~~~

1.4 Get the repository. Gitea is not running yet, so pull from the
precision-5560. LAN address of the 5560 is 192.168.86.142.

From the 5560, make a branch bundle once (it survives without git access):

~~~bash
cd ~/Projects/nixos-config
git bundle create /tmp/nixos-config.bundle --all
~~~

Then on the macmini, either over the LAN or from a USB stick:

~~~bash
scp uzair@192.168.86.142:/tmp/nixos-config.bundle ~/
git clone -b macmini-nixos ~/nixos-config.bundle ~/nixos-config
cd ~/nixos-config && git log --oneline -1
~~~

If scp is refused, copy the bundle on a USB stick and clone from that path.
Do not clone from GitHub: the branch is local only.

---

## 2. hardware-configuration.nix

This file is generated, never hand-written.

~~~bash
sudo nixos-generate-config --show-hardware-config > \
  ~/nixos-config/hosts/macmini/system/hardware-configuration.nix
~~~

Then check three things:

~~~bash
grep -n 'fileSystems\|swapDevices\|boot.loader' \
  ~/nixos-config/hosts/macmini/system/hardware-configuration.nix
~~~

- fileSystems."/" must point at the SSD by UUID, not at /dev/sda2.
- fileSystems."/boot" (or /boot/efi) must be the SSD's ESP.
- Any boot.loader.grub line should be deleted; you use systemd-boot.

The import line for this file is already present but commented in
hosts/macmini/system/default.nix. Uncomment it.

Optional but sensible on 16 GB: add 8 GB of swap. Add to the same file:

~~~nix
  swapDevices = [ { device = "/var/swapfile"; size = 8192; }; ];
~~~

---

## 3. bootloader.nix

You are writing this yourself. A working template for this machine:

~~~nix
{pkgs, ...}: {
  boot.loader.systemd-boot.enable = true;

  # Apple firmware: do not write EFI variables. bootctl installs the
  # removable fallback at EFI/BOOT/BOOTX64.EFI, which the Mac boots on its
  # own. If you ever get a blank screen, that fallback is the first suspect.
  boot.loader.efi.canTouchEfiVariables = false;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # The 2012 mini has no T2 and no LUKS in this build. If you add LUKS later,
  # boot.initrd.luks.devices goes here.
}
~~~

Then uncomment the ./bootloader.nix import in default.nix.

---

## 4. First switch

~~~bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#macmini
~~~

Expected failures on this first run, all intentional:

- paperless: passwordFile points at an agenix secret that is not encrypted yet.
- cloudflared: credentials secret is empty.
- restic: password secret is empty.

Everything else (postgresql, gitea, syncthing, home-assistant, minecraft,
docker, sshd) should come up.

Verify:

~~~bash
systemctl --failed
systemctl status gitea syncthing docker
ss -tlnp | grep -E '22|3000|8123|8384|25565|28981'
~~~

If the build fails, the error is almost always one of: a path in
hardware-configuration.nix pointing at the wrong disk, a missing semicolon in
bootloader.nix, or an option renamed by a nixpkgs update. Read the first
error line, not the stack trace.

---

## 5. Secrets (agenix)

Three encrypted files live in hosts/macmini/secrets/. They are empty
placeholders, which is why paperless, cloudflared and restic are red.

5.1 Get the host's age public key:

~~~bash
ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
~~~

5.2 Put it in hosts/macmini/secrets/secrets.nix as the macmini recipient:

~~~nix
let
  macmini = "age1...";
in {
  "paperless-admin-password.age".publicKeys = [macmini];
  "restic-password.age".publicKeys = [macmini];
  "cloudflared-credentials.age".publicKeys = [macmini];
}
~~~

5.3 On a workstation that has an age identity (default
~/.config/age/keys.txt), from the repo root:

~~~bash
nix shell nixpkgs#agenix -c agenix -e hosts/macmini/secrets/paperless-admin-password.age
nix shell nixpkgs#agenix -c agenix -e hosts/macmini/secrets/restic-password.age
nix shell nixpkgs#agenix -c agenix -e hosts/macmini/secrets/cloudflared-credentials.age
~~~

Contents:

- paperless-admin-password: one line, the admin password.
- restic-password: one line, long random. Save it in a password manager.
  Without it the backup repository cannot be opened, ever.
- cloudflared-credentials: the tunnel credentials JSON, verbatim, from the
  Cloudflare dashboard (section 12). You can leave this one for later.

5.4 Commit and switch again:

~~~bash
git add hosts/macmini/secrets && git commit -m "secrets: encrypt macmini"
sudo nixos-rebuild switch --flake .#macmini
systemctl status paperless
journalctl -u paperless -n 40
~~~

If agenix fails at activation with a decryption error, the recipient in
secrets.nix does not match the host key. Re-run 5.1 and re-encrypt.

---

## 6. SSH access

6.1 From the precision-5560, create a normal key for this server:

~~~bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_macmini -C uzair@precision-5560
cat ~/.ssh/id_ed25519_macmini.pub
~~~

6.2 Paste the .pub line into users.users.uzair.openssh.authorizedKeys.keys in
hosts/macmini/system/ssh.nix, then switch.

6.3 Test from the 5560 before touching password auth:

~~~bash
ssh -i ~/.ssh/id_ed25519_macmini uzair@100.95.56.35
~~~

The macmini's Tailscale address changes after reinstall until you re-auth
(section 14). Until then use the LAN address.

6.4 Only after a successful key login, set PasswordAuthentication = false in
ssh.nix and switch again. The box is headless: a mistake here costs you a
monitor and keyboard.

A note on YubiKey keys: your FIDO2 resident credentials are scoped to the
applications ssh:github-auth and ssh:git-signing. OpenSSH only offers a
credential for host authentication when its application is the default
"ssh:", so those two will not get you a shell. If you want YubiKey login,
create one with -O application=ssh: as shown in ssh.nix.

---

## 7. Restore Gitea

Source data on the 5560 (backed up per Appendix A):

- gitea.sql (single-database dump, from postgres:14)
- gitea-data.tar.gz (the container's /data: repositories, avatars, LFS)
- gitea-compose.yaml (reference only)

7.1 Stop the service so nothing writes during the restore:

~~~bash
sudo systemctl stop gitea
~~~

7.2 Restore the database. The NixOS module has already created the gitea
role and database and uses peer auth over the socket:

~~~bash
sudo -u gitea psql -d gitea -f ~/backup/gitea.sql
~~~

If that fails with a permissions error, drop and recreate first:

~~~bash
sudo -u postgres psql -c 'DROP DATABASE gitea;'
sudo -u postgres psql -c 'CREATE DATABASE gitea OWNER gitea;'
sudo -u gitea psql -d gitea -f ~/backup/gitea.sql
~~~

7.3 Restore the data. This is where ownership goes wrong: the container used
uid 1000, NixOS uses the git user.

~~~bash
sudo tar xzf ~/backup/gitea-data.tar.gz -C /var/lib/gitea --strip-components=1
sudo chown -R git:git /var/lib/gitea
sudo systemctl start gitea
~~~

7.4 Verify:

~~~bash
curl -sI http://127.0.0.1:3000 | head -3
sudo journalctl -u gitea -n 30
git clone ssh://git@127.0.0.1:2222/uzair/nixos-config /tmp/gitea-test
~~~

Clone URLs change: the old container exposed SSH on 2112 and HTTP on 3112,
NixOS uses 2222 and 3000 (3000 is loopback-only).

---

## 8. Restore Paperless

Source data: paperless.sql (from postgres:13), paperless-files.tar.gz
(data, media, consume, export).

The database engine changed 13 to 16. Never copy the old data directory;
dump and restore as below.

8.1 Stop the service:

~~~bash
sudo systemctl stop paperless
~~~

8.2 Restore files:

~~~bash
sudo tar xzf ~/backup/paperless-files.tar.gz -C /var/lib/paperless
sudo chown -R paperless:paperless /var/lib/paperless
~~~

The tar contains data/, media/, consume/, export/. They land directly under
/var/lib/paperless, which is exactly what paperless.nix expects.

8.3 Restore the database:

~~~bash
sudo -u postgres psql -c 'DROP DATABASE IF EXISTS paperless;'
sudo -u postgres psql -c 'CREATE DATABASE paperless OWNER paperless;'
sudo -u paperless psql -d paperless -f ~/backup/paperless.sql
~~~

8.4 Start and verify:

~~~bash
sudo systemctl start paperless
curl -sI http://127.0.0.1:28981 | head -3
journalctl -u paperless -n 50
~~~

8.5 Admin login. The password comes from the agenix secret
paperless-admin-password. If the web UI rejects the login with a CSRF error,
add to paperless.nix:

~~~nix
PAPERLESS_CSRF_TRUSTED_ORIGINS = "https://docs.uzair.page";
~~~

8.6 Scanner. The Samba share "scans" points at /var/lib/paperless/consume,
guest-writable, forced to the paperless user, SMB2 minimum. From the printer,
browse to the macmini and scan to that share. A file appearing in consume/
should be picked up within a minute.

~~~bash
smbclient -L //localhost -N
~~~

---

## 9. Restore Minecraft

Source: ~/Documents/minecraft-server from the old system, layout data/, mods/,
plugins/, config/. It was 4.2 GB.

~~~bash
sudo mkdir -p /srv/minecraft
sudo tar xzf ~/backup/minecraft.tar.gz -C /srv/minecraft
sudo chown -R root:root /srv/minecraft
sudo systemctl start docker-homeassistant  # sanity: docker is up
sudo systemctl start docker-minecraft
journalctl -u docker-minecraft -f
~~~

Wait for "Done" in the log, then verify the world, not just the port:

~~~bash
ss -tlnp | grep 25565
~~~

The container has ENABLE_AUTOPAUSE on: it stops when empty and starts on a
connection. A refused connection after idling is normal, the first connect
wakes it.

The old install ran under ~/Documents/minecraft-server with its own compose
file; the compose file itself is not needed, minecraft.nix reproduces it.

---

## 10. Syncthing

Data is disposable, so this is a re-pair, not a restore.

- NixOS runs Syncthing natively as uzair, data at
  /home/uzair/Documents/syncthing, config in .../config.
- GUI is 127.0.0.1:8384 only. Reach it via SSH tunnel:
  ssh -L 8384:127.0.0.1:8384 uzair@<macmini>
  or through the Cloudflare Tunnel at syncthing.uzair.page.
- The device ID changes. On each laptop and phone, remove the old macmini
  device and add the new ID.
- Recreate the folders you actually use. The old config had Music, Secrets and
  Resumable; only recreate what you still want, since the data was disposable.

~~~bash
systemctl status syncthing
sudo -u uzair syncthing --device-id
~~~

---

## 11. Home Assistant

Config volume: /var/lib/hass (host networking, privileged, so mDNS discovery
works).

~~~bash
sudo mkdir -p /var/lib/hass
sudo systemctl start docker-homeassistant
journalctl -u docker-homeassistant -f
curl -sI http://127.0.0.1:8123 | head -3
~~~

Known gap: the old Ubuntu system ran a second container, matter-server
(ghcr.io/home-assistant-libs/python-matter-server). The NixOS config does not
have it. If you use Matter devices, either re-pair them (they lose their
commissioning data when the server disappears) or add a second oci-container
with a persistent volume before you start Home Assistant.

Home Assistant history and config are expendable per your own priorities, so a
fresh start is acceptable. If you do want the old config, copy
~/Documents/Hass/config into /var/lib/hass before first start.

---

## 12. Cloudflare Tunnel

This replaces nginx and certbot entirely. No inbound ports, nothing to renew,
no port forwarding on the router.

Ingress, as configured in tunnel.nix:

~~~text
casa.uzair.page       -> http://127.0.0.1:8123    Home Assistant
docs.uzair.page       -> http://127.0.0.1:28981   Paperless
git.uzair.page        -> http://127.0.0.1:3000    Gitea
syncthing.uzair.page  -> http://127.0.0.1:8384    Syncthing
~~~

12.1 In the Cloudflare dashboard for uzair.page:
Zero Trust -> Networks -> Tunnels -> Create a tunnel -> Cloudflared.
Name it macmini.

12.2 Add the four public hostnames above, each with the matching
http://127.0.0.1:PORT service. Cloudflare creates the proxied CNAMEs itself.

12.3 Download the tunnel credentials JSON. Encrypt it into the
cloudflared-credentials secret (section 5), then:

~~~bash
sudo nixos-rebuild switch --flake .#macmini
systemctl status cloudflared-tunnel-macmini
journalctl -u cloudflared-tunnel-macmini -n 50
curl -sI https://docs.uzair.page | head -3
~~~

12.4 Only once every hostname answers through the tunnel, delete the old
A/AAAA records that point at the WAN IP, and stop certbot on the old HDD. The
nginx vhosts and /etc/letsencrypt are now reference material, not a fallback.

12.5 Tailscale keeps working independently. The tunnel is only for public
hostnames; everything else stays tailnet-only.

---

## 13. Restic backups

Direction: macmini to precision-5560 over SFTP. The repository directory
already exists on the 5560 at /home/uzair/backups/macmini.

What is backed up, from backup.nix:

- /var/lib/gitea and /var/lib/paperless (the two that matter)
- /srv/minecraft
- /var/lib/hass
- /home/uzair/.openclaw
- /etc/nixos

Excluded: /var/lib/docker (recreatable), and OpenClaw cache, tmp, browser, npm.

13.1 Restic runs as root, so root needs a key the 5560 accepts:

~~~bash
sudo ssh-keygen -t ed25519 -N "" -C macmini-restic -f /root/.ssh/id_ed25519
sudo cat /root/.ssh/id_ed25519.pub
~~~

Append that line to uzair@precision-5560:~/.ssh/authorized_keys.

13.2 First run and check:

~~~bash
sudo systemctl start restic-backups-macmini
sudo journalctl -u restic-backups-macmini -n 60
sudo systemctl list-timers | grep restic
~~~

13.3 Prove a restore, do not assume it:

~~~bash
sudo restic -r sftp:uzair@100.117.32.104:/home/uzair/backups/macmini \\
  --password-file /run/agenix/restic-password snapshots
sudo restic -r sftp:uzair@100.117.32.104:/home/uzair/backups/macmini \\
  --password-file /run/agenix/restic-password restore latest \\
  --target /tmp/restore --include /var/lib/gitea
ls /tmp/restore/var/lib/gitea
~~~

Restic never exposes the password in the unit file; it reads the agenix
secret. If the repository password is lost, the backups are unreadable, which
is why section 5 tells you to store it twice.

---

## 14. OpenClaw on the new system

This is the machine that was running the gateway. Its state is in the
Appendix A backup.

14.1 nix-openclaw runs the gateway as a home-manager user service,
bind = tailnet, port 18789. In Nix mode the configuration comes from
hosts/macmini/home/openclaw.nix; openclaw.json is not the source of truth.

Restore only what Nix does not own:

~~~bash
systemctl --user stop openclaw-gateway 2>/dev/null || true
mkdir -p ~/.openclaw/state
cp ~/backup/openclaw/openclaw.sqlite ~/.openclaw/state/openclaw.sqlite
cp -a ~/backup/openclaw/media ~/.openclaw/media
cp -a ~/backup/openclaw/workspace* ~/.openclaw/
~~~

Do not restore openclaw.json over the Nix-managed config. Re-add provider
credentials through the config/secrets path the flake expects instead.

14.2 Re-auth Tailscale (the device is new after a reinstall):

~~~bash
sudo tailscale up
tailscale status
~~~

The tailnet name should come back as macmini.tail9b9448.ts.net, which is what
the device-pair publicUrl in openclaw.nix expects.

14.3 If device pairing needs TLS, serve the gateway over Tailscale:

~~~bash
sudo tailscale serve --bg --https=8443 http://127.0.0.1:18789
tailscale serve status
~~~

14.4 Start and check:

~~~bash
systemctl --user status openclaw-gateway
openclaw status
~~~

14.5 gog on a tty: authenticate with the manual or remote flow. The file
keyring needs GOG_KEYRING_PASSWORD as an env-kind secret, not a secret-kind
one, or the keyring cannot be unlocked headlessly.

14.6 Todoist: it is a hosted MCP server at https://ai.todoist.net/mcp with
OAuth. On the first use, openclaw prints a URL; approve it from your phone.
No plugin install is involved.

---

## 15. Final checks

~~~bash
systemctl --failed
ss -tlnp | grep -v 127.0.0.1
sudo nixos-rebuild boot --flake .#macmini   # only after everything works
sudo nix-collect-garbage --delete-older-than 14d
df -h /
tailscale status
~~~

Expected listening state:

- 22 sshd (LAN and tailnet)
- 2222 gitea ssh
- 8123 Home Assistant
- 25565 Minecraft
- everything else on 127.0.0.1 only

Rollback: power off, reconnect the old HDD, hold Option at boot, pick the HDD.
Do not run the NixOS installer again with both disks attached until you have
confirmed the SSD boot works.

---

## Appendix A: before you wipe (while Ubuntu still runs)

Do this while everything still works. All of it lands on the 5560.

~~~bash
mkdir -p ~/backup
cd ~/Documents/Gitea
docker compose stop
docker exec gitea-db-1 pg_dump -U gitea gitea > ~/backup/gitea.sql
sudo tar czf ~/backup/gitea-data.tar.gz -C ~/Documents/Gitea gitea
cp docker-compose.yaml ~/backup/gitea-compose.yaml
docker compose start

cd ~/Documents/paperless-ngx
docker compose stop
docker exec paperless-db-1 pg_dump -U paperless paperless > ~/backup/paperless.sql
sudo tar czf ~/backup/paperless-files.tar.gz data media consume export
cp docker-compose.yml ~/backup/paperless-compose.yml
docker compose start

sudo tar czf ~/backup/minecraft.tar.gz -C ~/Documents minecraft-server
cp ~/Documents/Hass/config -r ~/backup/hass-config        # optional
cp -a /etc/nginx ~/backup/nginx
sudo cp -a /etc/letsencrypt ~/backup/letsencrypt
cp /etc/hosts /etc/fstab /etc/docker/daemon.json ~/backup/

systemctl --user stop openclaw-gateway
mkdir -p ~/backup/openclaw
sqlite3 ~/.openclaw/state/openclaw.sqlite ".backup $HOME/backup/openclaw/openclaw.sqlite"
cp -a ~/.openclaw/media ~/backup/openclaw/media
cp -a ~/.openclaw/workspace ~/.openclaw/workspace-linnea \
      ~/.openclaw/workspace-alhaitham ~/backup/openclaw/
cp ~/.openclaw/openclaw.json ~/backup/openclaw/     # reference only
systemctl --user start openclaw-gateway

rsync -avh --progress ~/backup/ uzair@100.117.32.104:/home/uzair/macmini-backup/
~~~

Then verify the copy on the 5560 before formatting anything:

~~~bash
ssh uzair@100.117.32.104 'ls -lh ~/macmini-backup; du -sh ~/macmini-backup'
~~~

Sizes to expect: gitea ~1.4 GB, paperless ~174 MB, minecraft ~4.2 GB,
OpenClaw state ~98 MB plus workspaces.

Skip API keys; regenerate them. Keep the restic password and the paperless
admin password out of the backup directory and in your password manager.
