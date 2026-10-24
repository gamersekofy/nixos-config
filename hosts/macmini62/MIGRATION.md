# macmini62 — Late 2012 Mac mini, Ubuntu to NixOS

The whole migration in order. Phase 0 and Phase 1 happen while the old system
still works. Phase 2 wipes the SSD, never the HDD. Phases 3 to 6 bring the new
system up and put the data back.

## What this machine is

| | |
|---|---|
| Model | Macmini6,x, Late 2012, 16 GB RAM |
| New disk | 1 TB Samsung 870 EVO SSD (SATA) |
| Rollback disk | 465 GB HDD, Ubuntu 24.04.5, untouched |
| Hostname | macmini62 |
| Tailnet name | macmini62.tail9b9448.ts.net |
| Services kept | Home Assistant, Gitea, Paperless-ngx, Syncthing, Minecraft |
| Services retired | Pingvin, Slash, Passbolt |

Data priority: Gitea, Paperless and Minecraft must survive. Syncthing and Home
Assistant are expendable, though Home Assistant is cheap to keep and Matter
devices are not, so back them up anyway.

## Rules

1. Never have both disks connected while installing. Unplug the HDD's SATA
   cable. It is the only rollback you have.
2. Never format, repartition or "clean up" the HDD.
3. Never copy a PostgreSQL data directory across major versions. Dump and
   restore.
4. No secret ever enters git in plaintext. Only `.age` files.
5. Keep the HDD intact for at least 30 days after cutover. Label it.

## Phases

| Phase | Where | What |
|---|---|---|
| 0 | precision-5560 | Prepare keys, passwords, tunnel, bundle |
| 1 | Mac mini, Ubuntu running | Dump and copy every byte of data |
| 2 | Mac mini, installer | Partition the SSD, install a minimal NixOS |
| 3 | macmini62 | Repo, hardware config, bootloader, build |
| 4 | both | Encrypt secrets, first full switch |
| 5 | macmini62 | Put the data back, service by service |
| 6 | both | Cut over, verify, keep the rollback |

---

# Phase 0 — on precision-5560, before you open the Mac mini

Everything here is preparation. None of it touches the old system.

## 0.1 Landing zone

~~~bash
df -h /home
mkdir -p ~/backups/macmini62/staging
~~~

You need about 10 GB free: roughly 6 GB of data plus room for the restic
repository later. Check the tools you will use:

~~~bash
command -v rsync git jq restic age ssh-to-age
nix run nixpkgs#ssh-to-age -- --help >/dev/null && echo ssh-to-age ok
nix shell nixpkgs#age -c age-keygen --help >/dev/null && echo age ok
~~~

## 0.2 Personal age key

This is the key you will use to create and edit secrets from the laptop. The
host has its own key; this one is yours.

~~~bash
ls ~/.config/age/keys.txt 2>/dev/null || \
  nix shell nixpkgs#age -c age-keygen -o ~/.config/age/keys.txt
nix shell nixpkgs#age -c age-keygen -y ~/.config/age/keys.txt
~~~

Record the public key. It goes into `hosts/macmini62/secrets/secrets.nix` as
`personal`. Back up `keys.txt` somewhere safe; without it you cannot re-encrypt
anything.

## 0.3 SSH key for the new host

~~~bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_macmini62 -C uzair@precision-5560
cat ~/.ssh/id_ed25519_macmini62.pub
~~~

That public line goes into `hosts/macmini62/system/ssh.nix` during Phase 3. Do
not reuse the YubiKey credentials scoped to `ssh:github-auth` or
`ssh:git-signing`: OpenSSH does not offer those for host authentication. A
YubiKey login needs a resident credential created with
`-O application=ssh:`.

## 0.4 Generate and store the passwords

Generate them now, so the values exist before you need to encrypt them. Store
each in your password manager as you go; do not leave them in shell history.

~~~bash
openssl rand -base64 48   # restic repository password
openssl rand -base64 24   # paperless admin password
openssl rand -base64 24   # syncthing GUI password
openssl rand -base64 24   # gog file-keyring password
openssl rand -hex 32      # openclaw gateway token
~~~

Also collect the provider API keys while the old OpenClaw instance still runs
(the current deepseek and zai keys). They go into the `openclaw-secrets` JSON,
not into git.

## 0.5 Cloudflare Tunnel

In the Cloudflare dashboard for uzair.page:

1. Zero Trust -> Networks -> Tunnels -> Create a tunnel -> Cloudflared.
2. Name it `macmini62`.
3. Add these public hostnames, each pointing at the local service:

~~~text
casa.uzair.page  -> http://127.0.0.1:8123     Home Assistant
docs.uzair.page  -> http://127.0.0.1:28981    Paperless
git.uzair.page   -> http://127.0.0.1:3000     Gitea
~~~

4. Download the credentials JSON and put it in the staging directory:

~~~bash
mv ~/Downloads/<tunnel-id>.json ~/backups/macmini62/staging/cloudflared-credentials.json
chmod 600 ~/backups/macmini62/staging/cloudflared-credentials.json
~~~

Do not delete the old DNS records yet. They stay until Phase 6.

## 0.6 Build the offline bundle

The new host has no Gitea yet, so it clones from a file. On the 5560:

~~~bash
cd ~/Projects/nixos-config
git status --short          # expect the macmini62 tree to be committed or staged
git bundle create /tmp/nixos-config.bundle --all
git bundle list-heads /tmp/nixos-config.bundle | head
~~~

Rebuild this bundle after Phase 4 encrypts the secrets; the first clone will
not have them.

## 0.7 Prove the tree evaluates

The two generated files do not exist yet, so evaluation stops at the fileSystems
and bootloader assertions. That is expected. Everything else should be clean:

~~~bash
cd ~/Projects/nixos-config
nix eval --no-write-lock-file \
  .#nixosConfigurations.macmini62.config.system.build.toplevel.drvPath
~~~

---

# Phase 1 — on the Mac mini, while Ubuntu still runs

Do all of this before removing a single screw. Work as `uzair`.

## 1.1 Sanity check

~~~bash
df -h /
docker ps --format '{{.Names}}\t{{.Status}}'
~~~

You need about 7 GB free in `/home` for the archives.

## 1.2 Gitea

~~~bash
cd ~/Documents/Gitea
docker compose exec -T server sh -c 'find /data -maxdepth 3 -type d | sort' \
  > ~/backup/gitea-layout.txt
docker compose exec -T db pg_dump -U gitea --no-owner --no-acl gitea \
  > ~/backup/gitea.sql
docker compose stop server
sudo tar czf ~/backup/gitea-data.tar.gz gitea
docker compose start server
cp docker-compose.yaml ~/backup/gitea-compose.yaml
ls -lh ~/backup/gitea*
~~~

The tar is created from `~/Documents/Gitea`, so its root entry is `gitea/`,
which is the container's `/data` volume. Keep it that way; Phase 5 depends on
it.

## 1.3 Paperless

~~~bash
cd ~/Documents/paperless-ngx
docker compose exec -T db pg_dump -U paperless --no-owner --no-acl paperless \
  > ~/backup/paperless.sql
docker compose stop webserver
sudo tar czf ~/backup/paperless-files.tar.gz data media consume export
docker compose start webserver
cp docker-compose.yml docker-compose.env ~/backup/ 2>/dev/null || true
ls -lh ~/backup/paperless*
~~~

The tar root entries are `data/`, `media/`, `consume/` and `export/`. Phase 5
extracts them straight into `/var/lib/paperless`.

## 1.4 Minecraft

Stop the container first. A running world copies as a torn region file and
Minecraft will regenerate chunks you already explored.

~~~bash
cd ~/Documents/minecraft-server
docker compose stop minecraft
sudo tar czf ~/backup/minecraft.tar.gz -C ~/Documents minecraft-server
docker compose start minecraft
ls -lh ~/backup/minecraft.tar.gz
~~~

Root entry is `minecraft-server/` with `data/`, `mods/`, `plugins/`,
`config/` inside. If your layout differs, run
`tar tzf ~/backup/minecraft.tar.gz | head -20` and adjust `--strip-components`
in Phase 5.

## 1.5 Home Assistant and Matter

~~~bash
cd ~/Documents/Hass
docker compose stop homeassistant matter-server
cp -a config ~/backup/hass-config
cp -a opt/matter-server ~/backup/matter-server
docker compose start matter-server homeassistant
~~~

`hass-config` is the container's `/config`, containing `.storage`, the
database and `configuration.yaml`. `matter-server` holds the Matter fabric;
without it every Matter device must be re-commissioned.

The old compose also mounted your Music folder and an images path into the HA
container. Those mounts are not reproduced in `hass.nix`; see Appendix D.

## 1.6 OpenClaw

~~~bash
systemctl --user stop openclaw-gateway
sudo tar czf ~/backup/openclaw.tar.gz -C ~/.openclaw \
  --exclude=cache --exclude=tmp --exclude=browser --exclude=npm .
cp ~/.openclaw/openclaw.json ~/backup/openclaw.json
systemctl --user start openclaw-gateway
~~~

`openclaw.json` is a reference only. Never restore it over the Nix-managed
config; the ported version is `hosts/macmini62/home/openclaw.nix`.

## 1.7 Reference copies

~~~bash
cp /etc/hosts /etc/fstab ~/backup/
sudo cp -a /etc/nginx ~/backup/nginx
sudo cp -a /etc/letsencrypt ~/backup/letsencrypt
docker ps --format '{{.Names}}' > ~/backup/containers.txt
~~~

## 1.8 Transfer and verify

~~~bash
cd ~/backup
sha256sum * > SHA256SUMS
rsync -avh --progress ~/backup/ \
  uzair@192.168.86.142:/home/uzair/backups/macmini62/staging/
~~~

Then on the 5560, verify before you touch the hardware:

~~~bash
cd ~/backups/macmini62/staging
sha256sum -c SHA256SUMS
du -sh .
tar tzf gitea-data.tar.gz | head -5
tar tzf paperless-files.tar.gz | head -5
tar tzf minecraft.tar.gz | head -5
grep -c 'CREATE TABLE' gitea.sql
grep -c 'CREATE TABLE' paperless.sql
~~~

Expected sizes: gitea about 1.4 GB, paperless about 174 MB, minecraft about
4.2 GB, Home Assistant a few hundred MB, OpenClaw about 100 MB. If a count is
zero, the dump failed; do not proceed.

## 1.9 Open the machine

~~~bash
sudo poweroff
~~~

Unplug the HDD SATA cable, remove the HDD, and fit the SSD. Keep the HDD in an
anti-static bag, labelled, with the date.

---

# Phase 2 — install NixOS on the SSD

## 2.1 Installer

Write a NixOS minimal ISO to a USB stick (`dd` or balenaEtcher), insert it, and
hold Option at the chime. Pick "EFI Boot".

Use Ethernet. The 2012 mini's Wi-Fi is a BCM4331 and needs `broadcom-sta` plus
firmware that the minimal ISO does not carry.

## 2.2 Identify the disk

~~~bash
lsblk -o NAME,SIZE,MODEL
~~~

With the HDD removed the SSD is normally `/dev/sda`. Confirm the size is
~1 TB, not 465 GB. If you see two disks, stop: the HDD is still connected.

## 2.3 Partition and format

~~~bash
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart ESP fat32 1MiB 513MiB
sudo parted /dev/sda -- set 1 esp on
sudo parted /dev/sda -- mkpart nixos ext4 513MiB 100%
sudo mkfs.fat -F 32 -n ESP /dev/sda1
sudo mkfs.ext4 -L nixos /dev/sda2
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/ESP /mnt/boot
~~~

The ESP is mounted at `/boot`, which is systemd-boot's default mount point. Do
not use `/boot/efi` here.

## 2.4 Minimal configuration

~~~bash
sudo nixos-generate-config --root /mnt
sudo $EDITOR /mnt/etc/nixos/configuration.nix
~~~

Replace the body with this. It is deliberately minimal: no services, no
secrets, nothing that can fail activation before the host key exists.

~~~nix
{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "macmini62";
  networking.networkmanager.enable = true;

  services.openssh.enable = true;

  users.users.uzair = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme";
  };

  system.stateVersion = "26.11";
}
~~~

`canTouchEfiVariables = false` matters on Apple firmware: bootctl then installs
the removable fallback at `EFI/BOOT/BOOTX64.EFI`, which the Mac boots without
any NVRAM entry.

## 2.5 Install and reboot

~~~bash
sudo nixos-install --root /mnt
sudo reboot
~~~

Remove the USB stick. Hold Option at the chime and pick "EFI Boot". If you get
a blank screen, boot the installer again and check
`ls /mnt/boot/EFI/BOOT/BOOTX64.EFI` exists.

---

# Phase 3 — first boot, repo, hardware and bootloader

These commands run on macmini62, on the console.

## 3.1 Password and network

~~~bash
passwd
ip -brief addr
ping -c 2 1.1.1.1
~~~

If the link is down: `sudo nmcli device connect <ifname>`.

## 3.2 Flakes and the repo

~~~bash
export NIX_CONFIG='experimental-features = nix-command flakes'
mkdir -p ~/Projects
scp uzair@192.168.86.142:/tmp/nixos-config.bundle ~/
git clone -b macmini-nixos ~/nixos-config.bundle ~/Projects/nixos-config
cd ~/Projects/nixos-config && git log --oneline -1
~~~

If scp is refused, copy the bundle on a USB stick and clone from that path.

## 3.3 hardware-configuration.nix

Generated, never hand-written. Generate to a temp file so the repo copy is
owned by uzair:

~~~bash
sudo nixos-generate-config --show-hardware-config > /tmp/hw.nix
mv /tmp/hw.nix ~/Projects/nixos-config/hosts/macmini62/system/hardware-configuration.nix
grep -n 'fileSystems\|swapDevices\|boot.loader' \
  ~/Projects/nixos-config/hosts/macmini62/system/hardware-configuration.nix
~~~

Check:

- `fileSystems."/"` is the SSD partition by UUID.
- `fileSystems."/boot"` is the SSD's ESP by UUID.
- There is no `boot.loader.grub` line. If one appears, delete it.

Leave `swapDevices = [ ];` alone. `hosts/macmini62/system/default.nix` already
declares an 8 GB `/swapfile`, and list options merge.

## 3.4 bootloader.nix

Create `hosts/macmini62/system/bootloader.nix`:

~~~nix
{pkgs, ...}: {
  boot.loader.systemd-boot.enable = true;

  # Apple firmware: do not write EFI variables. bootctl installs the
  # removable fallback at EFI/BOOT/BOOTX64.EFI, which the Mac boots on its
  # own. If you ever get a blank screen, that fallback is the first suspect.
  boot.loader.efi.canTouchEfiVariables = false;

  # Only if hardware-configuration.nix mounts the ESP at /boot/efi:
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
~~~

## 3.5 Uncomment the imports

In `hosts/macmini62/system/default.nix`:

~~~nix
    ./bootloader.nix
    ./hardware-configuration.nix
~~~

## 3.6 SSH key

Paste the public key from Phase 0.3 into
`users.users.uzair.openssh.authorizedKeys.keys` in `ssh.nix`. Public keys only.

Leave `PasswordAuthentication = true` for now. It is the recovery path on a
headless box. Turn it off in Phase 6, after key login is proven.

## 3.7 Build without activating

~~~bash
cd ~/Projects/nixos-config
git add hosts/macmini62/system/hardware-configuration.nix \
        hosts/macmini62/system/bootloader.nix
sudo nixos-rebuild build --flake .#macmini62
~~~

Do not switch yet. The secret files are 0-byte placeholders, so activation
would fail. Building proves the tree evaluates; it never touches the secrets.

Common failures: a wrong UUID, an untracked new file (flakes ignore untracked
files), or a typo in `bootloader.nix`.

---

# Phase 4 — secrets, then the first full switch

## 4.1 Host age key

On macmini62:

~~~bash
nix run nixpkgs#ssh-to-age -- < /etc/ssh/ssh_host_ed25519_key.pub
~~~

That `age1...` string is the host recipient.

## 4.2 Fill the recipients

On the 5560, edit `hosts/macmini62/secrets/secrets.nix`:

~~~nix
let
  macmini62 = "age1...";   # from 4.1
  personal = "age1...";    # from Phase 0.2
in {
  "paperless-admin-password.age".publicKeys = [macmini62 personal];
  "restic-password.age".publicKeys = [macmini62 personal];
  "cloudflared-credentials.age".publicKeys = [macmini62 personal];
  "syncthing-password.age".publicKeys = [macmini62 personal];
  "openclaw-gateway-token.age".publicKeys = [macmini62 personal];
  "openclaw-secrets.age".publicKeys = [macmini62 personal];
  "gog-keyring-password.age".publicKeys = [macmini62 personal];
}
~~~

## 4.3 Encrypt the seven files

Run agenix from the secrets directory. The CLI looks for `secrets.nix` in the
current directory; from the repo root it fails with "agenix needs a rules
file". `nix shell nixpkgs#agenix` does not work either, because nixpkgs has no
`agenix` attribute.

~~~bash
cd ~/Projects/nixos-config/hosts/macmini62/secrets
mkdir -p ~/.config/age
~~~

Interactively, one at a time:

~~~bash
nix run github:ryantm/agenix -- -e paperless-admin-password.age \
  -i ~/.config/age/keys.txt
~~~

Or non-interactively, which also replaces the 0-byte placeholders cleanly:

~~~bash
printf '%s' "$RESTIC_PASSWORD" | \
  nix run github:ryantm/agenix -- -e restic-password.age \
  -i ~/.config/age/keys.txt
~~~

Contents:

| File | Contents |
|---|---|
| `paperless-admin-password.age` | one line, the admin password |
| `restic-password.age` | one line, long random |
| `cloudflared-credentials.age` | the tunnel JSON from 0.5, verbatim |
| `syncthing-password.age` | one line, plaintext GUI password |
| `openclaw-gateway-token.age` | JSON: `{"gatewayToken":"..."}` |
| `openclaw-secrets.age` | JSON: `{"deepseek":"...","zai":"..."}` |
| `gog-keyring-password.age` | one line, the gog keyring password |

Verify each one with your personal key:

~~~bash
nix run github:ryantm/agenix -- -d restic-password.age -i ~/.config/age/keys.txt
~~~

`agenix -c` is not a gate here: it only validates SSH-form recipients and says
"cannot check non-SSH recipient" for `ssh-to-age` output.

## 4.4 Commit, rebundle, pull, switch

On the 5560:

~~~bash
cd ~/Projects/nixos-config
git add hosts/macmini62/secrets
git commit -m "macmini62: encrypt secrets"
git bundle create /tmp/nixos-config.bundle --all
~~~

On macmini62:

~~~bash
scp uzair@192.168.86.142:/tmp/nixos-config.bundle ~/
cd ~/Projects/nixos-config
git fetch ~/nixos-config.bundle macmini-nixos
git reset --hard FETCH_HEAD
sudo nixos-rebuild switch --flake .#macmini62
~~~

## 4.5 Verify decryption

~~~bash
sudo ls -l /run/agenix/
systemctl --failed
systemctl status cloudflared-tunnel-macmini62 paperless
~~~

Every secret should be present with the owner and mode declared in
`secrets.nix`. A decryption error means the recipient does not match the host
key: re-run 4.1 and re-encrypt.

## 4.6 Restic root key

Restic runs as root. Its key must be authorised on the 5560.

~~~bash
sudo mkdir -p /root/.ssh && sudo chmod 700 /root/.ssh
sudo ssh-keygen -t ed25519 -N "" -C macmini62-restic -f /root/.ssh/id_ed25519
sudo cat /root/.ssh/id_ed25519.pub
~~~

Append that line to `uzair@precision-5560:~/.ssh/authorized_keys`. The 5560's
host key is already pinned in `backup.nix`.

---

# Phase 5 — put the data back

Copy the staging directory to macmini62 first:

~~~bash
rsync -avh uzair@192.168.86.142:/home/uzair/backups/macmini62/staging/ ~/backup/
ls -lh ~/backup
~~~

PostgreSQL roles and databases were created by the modules on the first switch.
Confirm before restoring:

~~~bash
sudo -u postgres psql -lqt | cut -d'|' -f1 | grep -E 'gitea|paperless'
~~~

## 5.1 Gitea

Target layout on NixOS:

~~~text
/var/lib/gitea/repositories   <- container /data/git/repositories
/var/lib/gitea/data           <- container /data/gitea
~~~

The service must be stopped while you write:

~~~bash
sudo systemctl stop gitea
~~~

Database. Read the dump through root's stdin so the `gitea` user never needs
access to `/home/uzair`:

~~~bash
sudo cat ~/backup/gitea.sql | sudo -u gitea psql -d gitea
~~~

If that fails on ownership, recreate the database and retry:

~~~bash
sudo -u postgres psql -c 'DROP DATABASE gitea;'
sudo -u postgres psql -c 'CREATE DATABASE gitea OWNER gitea;'
sudo cat ~/backup/gitea.sql | sudo -u gitea psql -d gitea
~~~

Files. Extract to a staging directory, never straight into place:

~~~bash
sudo install -d -o gitea -g gitea -m 0750 /var/lib/gitea/restore
sudo tar xzf ~/backup/gitea-data.tar.gz -C /var/lib/gitea/restore
sudo find /var/lib/gitea/restore -maxdepth 3 -type d | sort
~~~

With the archive root `gitea/`:

~~~bash
OLD=/var/lib/gitea/restore/gitea
sudo install -d -o gitea -g gitea -m 0750 \
  /var/lib/gitea/repositories /var/lib/gitea/data
sudo cp -a "$OLD/git/repositories/." /var/lib/gitea/repositories/
sudo cp -a "$OLD/gitea/." /var/lib/gitea/data/
# The container's app.ini would override NixOS settings. Drop it.
sudo rm -f /var/lib/gitea/data/conf/app.ini
sudo chown -R gitea:gitea /var/lib/gitea/repositories /var/lib/gitea/data
sudo rm -rf /var/lib/gitea/restore
~~~

Start and verify:

~~~bash
sudo systemctl start gitea
sudo journalctl -u gitea -n 40 --no-pager
curl -sI http://127.0.0.1:3000 | head -3
sudo -u gitea psql -d gitea -c 'select count(*) from repository;'
~~~

The count should match the number of repositories you had. NixOS runs Gitea as
`gitea`, not the container's `git` user; ownership must be `gitea:gitea`.

## 5.2 Paperless

Target layout:

~~~text
/var/lib/paperless/data     <- container ./data
/var/lib/paperless/media    <- container ./media
/var/lib/paperless/consume  <- container ./consume
~~~

~~~bash
sudo systemctl stop paperless
sudo tar xzf ~/backup/paperless-files.tar.gz -C /var/lib/paperless
sudo rm -rf /var/lib/paperless/data/index
sudo chown -R paperless:paperless /var/lib/paperless
~~~

The index is version-specific; Paperless rebuilds it. Everything else is
documents and thumbnails and must be kept.

Database, dumped from PostgreSQL 13 and restored into 16. Never copy the old
data directory:

~~~bash
sudo -u postgres psql -c 'DROP DATABASE IF EXISTS paperless;'
sudo -u postgres psql -c 'CREATE DATABASE paperless OWNER paperless;'
sudo cat ~/backup/paperless.sql | sudo -u paperless psql -d paperless
~~~

Start:

~~~bash
sudo systemctl start paperless
curl -sI http://127.0.0.1:28981 | head -3
sudo journalctl -u paperless -n 50 --no-pager
~~~

Admin password. The agenix password only seeds an empty database; the restored
one still carries the old hash. Reset it explicitly:

~~~bash
sudo -u paperless paperless-manage changepassword admin
~~~

Use the value stored for the `paperless-admin-password` secret so the secret
and the login stay consistent.

Scanner share: `scans` points at `/var/lib/paperless/consume`, guest-writable,
forced to `paperless`, SMB2 minimum.

~~~bash
smbclient -L //localhost -N
~~~

## 5.3 Minecraft

Target layout:

~~~text
/srv/minecraft/data      <- ./data     (world, server.properties, logs)
/srv/minecraft/mods      <- ./mods
/srv/minecraft/plugins   <- ./plugins
/srv/minecraft/config    <- ./config
~~~

~~~bash
sudo install -d -o root -g root -m 0755 /srv/minecraft
sudo tar xzf ~/backup/minecraft.tar.gz -C /srv/minecraft --strip-components=1
sudo find /srv/minecraft -maxdepth 1 -mindepth 1 | sort
ls -l /srv/minecraft/data/level.dat
~~~

Expected: `config`, `data`, `mods`, `plugins`. If the archive has a different
root, list it first with `tar tzf ~/backup/minecraft.tar.gz | head` and adjust
the strip count.

Ownership stays `root:root`; the itzg image runs as root and no PUID is set.

~~~bash
sudo systemctl start docker-minecraft
sudo journalctl -u docker-minecraft -f
~~~

Wait for "Done" in the log, then check the port. Do not judge by the port
alone; `level.dat` and a successful world load are the real test.

~~~bash
ss -tlnp | grep 25565
~~~

`ENABLE_AUTOPAUSE` is on, so the container stops when empty and the first
connection wakes it. A refused connection after idling is normal. The image is
pinned to `TYPE=FABRIC` and `VERSION=1.21.11` so it cannot silently start
vanilla and ignore the restored mods.

## 5.4 Home Assistant and Matter

~~~bash
sudo install -d -m 0755 /var/lib/hass /var/lib/matter-server
sudo cp -a ~/backup/hass-config/. /var/lib/hass/
sudo cp -a ~/backup/matter-server/. /var/lib/matter-server/
sudo chown -R root:root /var/lib/hass /var/lib/matter-server
~~~

Start Matter before Home Assistant: HA opens the Matter client on startup.

~~~bash
sudo systemctl start docker-matter-server
sudo systemctl start docker-homeassistant
sudo journalctl -u docker-homeassistant -n 50 --no-pager
curl -sI http://127.0.0.1:8123 | head -3
~~~

No `/dev/ttyUSB0` is passed through. There is no radio in this machine, and
Docker refuses to start a container whose `--device` path is missing. Add the
line back only when a stick is present.

Matter devices keep working only if `matter-server` data was restored; the
fabric lives there, not in HA.

## 5.5 Syncthing

Data is disposable. This is a re-pair, not a restore.

~~~bash
systemctl status syncthing
sudo -u uzair syncthing --device-id
~~~

The GUI is `127.0.0.1:8384`, loopback only, and requires the password from
`syncthing-password`. Reach it through an SSH tunnel:

~~~bash
ssh -L 8384:127.0.0.1:8384 uzair@macmini62.local
~~~

On precision-5560, update `hosts/precision-5560/system/syncthing.nix` with the
new device ID and rebuild. That host sets `overrideDevices = true`, so a GUI
edit there is reverted on the next switch.

Recreate only the folders you still use. The old config had Music, Secrets and
Resumable.

## 5.6 OpenClaw

Restore state, never the JSON:

~~~bash
systemctl --user stop openclaw-gateway 2>/dev/null || true
mkdir -p ~/.openclaw
tar xzf ~/backup/openclaw.tar.gz -C ~/.openclaw --exclude=openclaw.json
systemctl --user daemon-reload
~~~

Tailscale is a new device after the reinstall:

~~~bash
sudo tailscale up
tailscale status
~~~

Confirm the DNS name is exactly `macmini62.tail9b9448.ts.net`. The device-pair
URL in `openclaw.nix` is built from it:

~~~bash
tailscale status --json | jq -r .Self.DNSName
~~~

If Tailscale assigned a suffix (`macmini62-1`), fix the name in the admin
console or update `publicUrl` in `openclaw.nix`. Delete the old
`uzair-macmini` node.

Serve the gateway over Tailscale TLS. This is required: the gateway binds
loopback and the device-pair URL is `wss://` on 8443.

~~~bash
sudo tailscale serve --bg --https=8443 http://127.0.0.1:18789
tailscale serve status
systemctl --user start openclaw-gateway
systemctl --user status openclaw-gateway
openclaw status
~~~

Then, in order: gog authentication (file keyring password from agenix),
Todoist OAuth on first use, and confirm the deepseek and zai keys resolve from
`openclaw-secrets`. If a provider plugin still wants its own credentials, add
it to that JSON.

## 5.7 Cloudflare Tunnel

The tunnel was created in Phase 0.5 and its credentials are already encrypted,
so cloudflared started with the first switch. Verify:

~~~bash
systemctl status cloudflared-tunnel-macmini62
sudo journalctl -u cloudflared-tunnel-macmini62 -n 40 --no-pager
curl -sI https://docs.uzair.page | head -3
curl -sI https://git.uzair.page | head -3
curl -sI https://casa.uzair.page | head -3
~~~

Syncthing is deliberately not in the tunnel.

## 5.8 Restic

~~~bash
sudo systemctl start postgresqlBackup
sudo systemctl start restic-backups-macmini62
sudo journalctl -u restic-backups-macmini62 -n 60 --no-pager
sudo systemctl list-timers | grep -E 'restic|postgresqlBackup'
~~~

Prove a restore; do not assume it:

~~~bash
sudo restic -r sftp:uzair@100.117.32.104:/home/uzair/backups/macmini62 \
  --password-file /run/agenix/restic-password snapshots
sudo restic -r sftp:uzair@100.117.32.104:/home/uzair/backups/macmini62 \
  --password-file /run/agenix/restic-password restore latest \
  --target /tmp/restore --include /var/lib/gitea
ls /tmp/restore/var/lib/gitea
~~~

This 5560 target is a transition location, not a 3-2-1 backup. Add an
off-machine repository later.

---

# Phase 6 — cutover, verification, rollback

## 6.1 Turn off password auth

Only after a successful key login from the 5560:

~~~bash
ssh -i ~/.ssh/id_ed25519_macmini62 uzair@macmini62.local
~~~

Then set `PasswordAuthentication = false` in `ssh.nix` and switch again.

## 6.2 Remove the old edge

Once every hostname answers through the tunnel, delete the old A/AAAA records
that point at the WAN IP, and stop certbot/nginx on the old HDD (they are only
reachable if you boot it).

## 6.3 Final checks

~~~bash
systemctl --failed
ss -tlnp | grep -v 127.0.0.1
df -h /
free -h
tailscale status
sudo nixos-rebuild boot --flake .#macmini62
~~~

Expected listening state:

| Port | Service | Exposure |
|---|---|---|
| 22 | sshd | LAN and tailnet |
| 2222 | Gitea SSH | LAN and tailnet |
| 3000 | Gitea HTTP | loopback only |
| 8123 | Home Assistant | LAN and tunnel |
| 8384 | Syncthing GUI | loopback only |
| 25565 | Minecraft | LAN |
| 28981 | Paperless | loopback + tunnel |
| 445, 139 | Samba scans share | LAN |
| 22000 tcp/udp, 21027 udp | Syncthing | LAN |

## 6.4 Rollback

Power off, reconnect the HDD, hold Option at boot, pick the Ubuntu entry. The
SSD can stay installed; just make sure the firmware boots the HDD. Do not run
the installer again with both disks attached.

Keep the HDD for 30 days. After that, it is a spare disk, not a backup.

---

# Appendix A — where every byte goes

| Data | Staging file | Target on NixOS | Owner |
|---|---|---|---|
| Gitea repositories | `gitea-data.tar.gz` -> `gitea/git/repositories` | `/var/lib/gitea/repositories` | gitea:gitea |
| Gitea app data | same -> `gitea/gitea` | `/var/lib/gitea/data` (drop `conf/app.ini`) | gitea:gitea |
| Gitea database | `gitea.sql` (PG14 dump) | database `gitea` in PG16 | gitea |
| Paperless documents | `paperless-files.tar.gz` -> `data`, `media`, `consume` | `/var/lib/paperless/...` (drop `data/index`) | paperless:paperless |
| Paperless database | `paperless.sql` (PG13 dump) | database `paperless` in PG16 | paperless |
| Minecraft | `minecraft.tar.gz` -> `data`, `mods`, `plugins`, `config` | `/srv/minecraft/...` | root:root |
| Home Assistant | `hass-config/` | `/var/lib/hass` | root:root |
| Matter fabric | `matter-server/` | `/var/lib/matter-server` | root:root |
| OpenClaw state | `openclaw.tar.gz` (no `openclaw.json`) | `/home/uzair/.openclaw` | uzair |
| Reference only | `nginx/`, `letsencrypt/`, `*.sql`, `*compose*` | not restored | - |

# Appendix B — users and paths

| Thing | Value |
|---|---|
| Gitea user / state | `gitea` / `/var/lib/gitea` |
| Paperless user / root | `paperless` / `/var/lib/paperless` |
| Home Assistant | container, `/var/lib/hass` |
| Minecraft | container, `/srv/minecraft` |
| Syncthing | uzair, `/home/uzair/Documents/syncthing` |
| PostgreSQL | `postgresql_16`, socket `/run/postgresql` |
| Restic repository | `sftp:uzair@100.117.32.104:/home/uzair/backups/macmini62` |

# Appendix C — secrets

| Secret | Consumer |
|---|---|
| `paperless-admin-password` | Paperless admin seed / reset |
| `restic-password` | restic repository |
| `cloudflared-credentials` | cloudflared tunnel |
| `syncthing-password` | Syncthing GUI |
| `openclaw-gateway-token` | OpenClaw gateway auth |
| `openclaw-secrets` | deepseek and zai API keys |
| `gog-keyring-password` | gog file keyring |

# Appendix D — known deviations and deferred work

- Pingvin, Slash and Passbolt are not migrated. Their data stays on the HDD.
- Home Assistant's old compose mounted a Music folder and an images path into
  the container. Neither is reproduced. If an automation references
  `/media`, add a volume to `hass.nix` or copy the files into
  `/var/lib/hass/media`.
- Home Assistant's history is expendable. If you skip the config copy, start
  fresh and re-add integrations.
- The 2012 mini's Wi-Fi needs `broadcom-sta` and firmware. Ethernet is the
  supported path; enable `hardware.enableRedistributableFirmware` only if you
  actually need Wi-Fi.
- The tunnel exposes Gitea and Paperless to the public internet with only
  app-level login. Put Cloudflare Access in front of both.
- The restic repository on the 5560 is a transition target. Add an
  off-machine copy.
- Gitea SSH on 2222 is not proxied by the tunnel. Use HTTPS through the
  tunnel, or SSH over LAN/tailnet.
