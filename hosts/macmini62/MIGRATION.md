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
repository later. Only rsync and git need to be on PATH; everything else comes
from the nix store on demand:

~~~bash
command -v rsync git
nix shell nixpkgs#jq -c jq --version
nix shell nixpkgs#restic -c restic version
nix shell nixpkgs#age -c age-keygen --help >/dev/null && echo age ok
~~~

A local restic matters only on macmini62; here you need it to inspect the
repository from the 5560.

## 0.2 Personal age key

This is the key you will use to create and edit secrets from the laptop. The
host has its own key; this one is yours.

~~~bash
mkdir -p ~/.config/age && chmod 700 ~/.config/age
[ -f ~/.config/age/keys.txt ] || \
  nix shell nixpkgs#age -c age-keygen -o ~/.config/age/keys.txt
chmod 600 ~/.config/age/keys.txt
nix shell nixpkgs#age -c age-keygen -y ~/.config/age/keys.txt
~~~

When generating, age-keygen prints the public key to stderr and refuses to
overwrite an existing file. If keys.txt already exists, do not regenerate it:
the -y line prints the public key you need.

Record the public key. It goes into `hosts/macmini62/secrets/secrets.nix`
as `personal`. Back up `keys.txt` somewhere safe; without it you
cannot re-encrypt anything.

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

### The two JSON secrets, and where their contents come from

`openclaw-secrets.age` and `openclaw-gateway-token.age` are JSON documents.
There is no separate .json file in the repo because the .age files are 0-byte
placeholders until Phase 4; the JSON is what you encrypt into them.

Write both now, in the staging directory, so Phase 4 has something to encrypt:

~~~bash
umask 077
printf '{"deepseek":"","zai":""}\n' \
  > ~/backups/macmini62/staging/openclaw-secrets.json
printf '{"gatewayToken":"%s"}\n' "$(openssl rand -hex 32)" \
  > ~/backups/macmini62/staging/openclaw-gateway-token.json
chmod 600 ~/backups/macmini62/staging/openclaw-*.json
ls -l ~/backups/macmini62/staging/openclaw-*.json
~~~

Paste the provider keys into the empty strings. The member names must match the
SecretRef ids in `hosts/macmini62/home/openclaw.nix`: `/deepseek` and
`/zai`. The gateway token is wrapped in an object because the gateway reads
it with `id = "/gatewayToken"`.

OpenClaw cannot hand the old API keys back. `openclaw models auth list` shows
the saved profiles (deepseek and zai, both api_key mode), but there is no
export command, and secret-kind store entries are write-only by design. Take the
keys from the provider dashboards instead, and keep a copy in KeePass:

- https://platform.deepseek.com  -> API keys
- https://z.ai/manage-apikey    -> API keys

That matches the rule for this migration: keys are regenerated, not backed up.
The OpenAI profile is an OAuth login and does not migrate; re-authenticate on
the new host with `openclaw models auth login` once the gateway is up.

Delete both plaintext JSON files after Phase 4 encrypts them.

## 0.5 Cloudflare Tunnel

Cloudflare moved tunnels out of the Zero Trust section. Use the top-level
Networking entry, not Zero Trust -> Networks:

1. Networking -> Tunnels -> Create a tunnel -> Cloudflared.
2. Name it `macmini62`.
3. Skip the public hostname step. Leave the tunnel with no public hostnames for
   now; 5.7 binds them.

**Do not add the hostnames here.** Adding a public hostname creates a proxied
CNAME and replaces the existing record for that name, so casa/docs/git would
point at a tunnel with no connector (error 1033) while the Ubuntu box is still
serving them. Binding the hostnames is the cutover, not the preparation.

4. The setup screen now offers only an install command containing the tunnel
   token, per operating system. Ignore the install instructions -- especially
   the MSI, which the page defaults to. Nothing is installed from that page; the
   connector comes from NixOS. There is no JSON download any more.

This nixpkgs revision has only `credentialsFile` for a tunnel
(`nixos/modules/services/networking/cloudflared.nix`, the option at line 205),
loaded through systemd `LoadCredential`. There is no token option. So convert
the token into the credentials JSON once.

The token is base64url of `{"a":"<account>","t":"<tunnel>","s":"<secret>"}`, which is
why it starts with `eyJhIjoi`. Copy the long `eyJ...` string out of the install
command, then:

~~~bash
read -rs TOKEN; echo            # paste the token, press Enter; it will not echo
nix shell nixpkgs#nodejs -c node -e '
  const j = JSON.parse(Buffer.from(process.argv[1], "base64url"));
  process.stdout.write(JSON.stringify({
    AccountTag: j.a, TunnelID: j.t, TunnelSecret: j.s
  }) + "\n");
' "$TOKEN" \
  > ~/backups/macmini62/staging/cloudflared-credentials.json
unset TOKEN
chmod 600 ~/backups/macmini62/staging/cloudflared-credentials.json
head -c 40 ~/backups/macmini62/staging/cloudflared-credentials.json; echo
~~~

Expect `{"AccountTag":"...`, and `TunnelID` must equal the Tunnel ID shown on
the same dashboard page. A JSON parse error means the token was copied
partially; re-copy the whole string.

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

The tar root entries are data/, media/, consume/ and export/.

Skipped in this run. The restore path re-ingests the originals (5.2), and a
2.12.1 dump cannot be loaded into 3.1.3 anyway, so there is nothing here worth
falling back to. What matters from this step is extracting the PDFs with
readable names; see 1.4.

Extract the originals under their real titles, so a drag-and-drop later does not
produce 30 files called 0000094.pdf:

~~~bash
OUT=$HOME/backup/paperless-originals
mkdir -p "$OUT"
docker compose exec -T db psql -U paperless -d paperless -At -F '|' -c \
  "select id, regexp_replace(coalesce(nullif(title,''),'untitled'),
   '[^A-Za-z0-9 ._-]', '_', 'g') from documents_document order by id" \
| while IFS='|' read -r id title; do
    src=$(printf 'media/documents/originals/%07d.pdf' "$id")
    [ -f "$src" ] || continue
    cp -p "$src" "$(printf '%s/%04d - %s.pdf' "$OUT" "$id" "$title")"
  done
ls -1 "$OUT" | wc -l
du -sh "$OUT"
~~~

Thirty files, about 40 MB. The numeric prefix keeps duplicates distinct: eleven
documents are literally titled "scan".

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

Verify the archive is not only intact but loadable. A jar truncated to 0, 16K or
32K bytes still lists and extracts fine; it only fails at mod discovery with
"zip END header not found", which the server reports as a start failure.

~~~bash
gzip -t ~/backup/minecraft.tar.gz
cd ~/Documents/minecraft-server/data/mods
for f in *.jar; do unzip -tqq "$f" >/dev/null 2>&1 || echo "BAD $f"; done
~~~

This is not hypothetical: eleven jars on this instance were truncated long
before the backup, and the container had been crash-looping (34 restarts)
without anyone noticing. The pinned MODS list in minecraft.nix re-fetched all
eleven and the server reached "Done (11.773s)!".


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

The old gateway runs on this same machine. If you are talking to it, stopping it
kills the session mid-conversation, so do not use `systemctl --user stop` here.
A live SQLite snapshot is consistent without a stop.

What is worth keeping, and what is not:

~~~text
openclaw.json                 reference config, already ported to openclaw.nix
workspace/                    SOUL.md, USER.md, MEMORY.md, memory/, skills
state/openclaw.sqlite         session index, config history, secret store
cache/ tmp/ browser/ npm/     rebuildable, 2.4 GB of the 2.4 GB total
agents/*/agent/*.sqlite       chat transcripts and stale .bak files, 673 MB
~~~

~~~bash
mkdir -p ~/backup/openclaw
cp ~/.openclaw/openclaw.json ~/backup/openclaw/
tar czf ~/backup/openclaw/workspace.tar.gz -C ~/.openclaw workspace

node -e '
  const {DatabaseSync} = require("node:sqlite");
  new DatabaseSync(process.argv[1], {readOnly: true})
    .exec("VACUUM INTO \x27" + process.argv[2] + "\x27");
' ~/.openclaw/state/openclaw.sqlite ~/backup/openclaw/state-openclaw.sqlite

ls -lh ~/backup/openclaw/
~~~

About 35 MB. `VACUUM INTO` matters: the gateway keeps its database in WAL mode,
and a plain `cp` of a live database can capture a file whose pages are still
only in the -wal, which opens as a truncated database.

Chat history is not in this set. If you want it, snapshot the agent database
the same way (it is 673 MB, most of it old pre-migration backups):

~~~bash
ls -lh ~/.openclaw/agents/main/agent/*.sqlite*
~~~

`openclaw.json` is a reference only. Never restore it over the Nix-managed
config; the ported version is `hosts/macmini62/home/openclaw.nix`. Provider API
keys are not in any of this -- regenerated in 0.4, encrypted in 4.3.

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
find . -type f ! -name SHA256SUMS -print0 | sort -z \
  | xargs -0 sha256sum > SHA256SUMS
wc -l SHA256SUMS
rsync -a --info=progress2 ~/backup/ \
  uzair@192.168.86.142:/home/uzair/backups/macmini62/staging/
~~~

Then on the 5560, verify before you touch the hardware:

~~~bash
cd ~/backups/macmini62/staging
sha256sum -c SHA256SUMS        # every line must end in OK
du -sh .                       # about 5.3 GB
tar tzf gitea-data.tar.gz | head -5
tar tzf minecraft.tar.gz | head -5
grep -c 'CREATE TABLE' gitea.sql
find matter-server -name '*.json' -size +0 | head -3
~~~

Use `find`, not `sha256sum *`. The glob skips directories, so
hass-config, matter-server, openclaw and paperless-originals would be left out
of the manifest with no error.

Expected sizes: gitea about 1.5 GB, minecraft about 3.4 GB, hass-config about
180 MB, matter-server about 2 MB, openclaw about 320 MB, paperless-originals
about 40 MB. If a count is zero, the dump failed; do not proceed.

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
cat /etc/ssh/ssh_host_ed25519_key.pub
~~~

That SSH public key line is the host recipient. Use it verbatim, **not** its
`ssh-to-age` output: agenix decrypts with the SSH private key, and age's SSH
identity is not the same as the X25519 identity derived by `ssh-to-age`.

## 4.2 Fill the recipients

On the 5560, edit `hosts/macmini62/secrets/secrets.nix`:

~~~nix
let
  macmini62 = "ssh-ed25519 AAAA...";  # from 4.1, verbatim
  personal = "age1...";               # from Phase 0.2
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
"cannot check non-SSH recipient" for the personal `age1...` key.

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
systemctl status cloudflared-tunnel-macmini62 paperless-web
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

## 4.7 OpenClaw first light, before any data restore

OpenClaw is the service that helps with the rest of this migration, so bring it
up before touching Gitea, Paperless or Minecraft. By now 4.3 has decrypted the
secrets and the first switch has created the gateway unit.

Restore the workspace only. The config is Nix-managed and must not be replaced
(see the note in 5.6). The full staging tree is copied in Phase 5, so fetch just
the workspace archive now, from precision:

~~~bash
ssh uzair@192.168.86.120 'mkdir -p ~/backup/openclaw'
rsync -a --info=progress2 \
  ~/backups/macmini62/staging/openclaw/workspace.tar.gz \
  uzair@192.168.86.120:~/backup/openclaw/
~~~

Then on macmini62:

~~~bash
systemctl --user stop openclaw-gateway 2>/dev/null || true
tar xzf ~/backup/openclaw/workspace.tar.gz -C ~/.openclaw
chown -R uzair:users ~/.openclaw/workspace
~~~

That brings back SOUL.md, USER.md, MEMORY.md, memory/ and skills. It covers the
main agent only. `linnea` and `alhaitham` use separate `workspace-linnea` and
`workspace-alhaitham` directories; restore those from their git repositories:

~~~bash
git clone <linnea-repo> ~/.openclaw/workspace-linnea
git clone <alhaitham-repo> ~/.openclaw/workspace-alhaitham
~~~

Tailscale is a new device after the reinstall:

~~~bash
sudo tailscale up
sudo tailscale serve --bg --https=8443 http://127.0.0.1:18789
tailscale status --json | jq -r .Self.DNSName
~~~

The DNS name must be exactly `macmini62.tail9b9448.ts.net`: the device-pair
URL in openclaw.nix is built from it, and a `macmini62-1` suffix breaks that
URL. Delete the old `uzair-macmini` node from the tailnet.

~~~bash
systemctl --user start openclaw-gateway
systemctl --user status openclaw-gateway --no-pager
openclaw status
~~~

If the gateway restart-loops with `Refusing to run gateway state preparation
because this OpenClaw binary ... is older than the config last written by
OpenClaw ...`, update the flake input and rebuild:

~~~bash
nix flake update nix-openclaw
sudo nixos-rebuild switch --flake .#macmini62
~~~

Do not bypass this with `OPENCLAW_ALLOW_OLDER_BINARY_DESTRUCTIVE_ACTIONS`
unless you intentionally want a downgrade.

From the precision, confirm the gateway answers through Tailscale TLS:

~~~bash
curl -sS -o /dev/null -w '%{http_code}\n' https://macmini62.tail9b9448.ts.net:8443/
~~~

200 or 401 means reachable; 401 is the expected answer without a token. A
connection refused means `tailscale serve` is not running; a timeout means the
tailnet name is wrong.

### Pairing the precision node

The node service is Nix-managed (`openclaw-node.service`), so do not use
`openclaw connect --service`, which would write its own unit. After precision
has been rebuilt with the updated `gatewayHost`, mint a single-use join code on
macmini62:

~~~bash
openclaw devices join-code
~~~

On precision-5560, pair and save the device token:

~~~bash
systemctl --user stop openclaw-node
openclaw connect '<join-url>' --display-name precision-5560
~~~

Wait for `node host gateway connected`, then Ctrl-C. Start the Nix-managed
service and confirm the gateway sees it:

~~~bash
systemctl --user start openclaw-node
openclaw node status
~~~

On macmini62:

~~~bash
openclaw nodes list
~~~

The gateway's `gateway.nodes.commands.allow` permits `file.fetch`, `dir.list`,
`dir.fetch`, `system.run`, `system.run.prepare` and `system.which`. After the
node reconnects, approve its expanded command surface:

~~~bash
openclaw nodes pending
openclaw nodes approve <nodeRequestId>
~~~

That approval is separate from device pairing. To make node exec the default,
set `tools.exec.host` to `node`; otherwise request it per session with
`/exec host=node`.

If the node logs `device token mismatch`, the saved token is from the old
gateway. Mint a fresh join code and repeat the `openclaw connect` step; the old
token is replaced in place.

### External plugins and model credentials

`programs.openclaw.runtimePlugins` installs the official external plugins
through nix-openclaw. Do not use `openclaw plugins install` or
`openclaw doctor --fix` against a Nix-managed config; both try to write
`openclaw.json`. Rebuild the host after changing the plugin list.

The `zai`, `deepseek` and `typesafe` credentials are resolved from
`/run/agenix/openclaw-secrets` (JSON keys `zai`, `deepseek`, `typesafe`).
Changing a key means editing the `.age` file and switching again; restarting the
gateway alone does not re-decrypt it.

OpenAI Codex/ChatGPT OAuth is different: the account token lives in the SQLite
state, not `openclaw.json`, so it can be connected from Control UI → Settings →
Models → Connect provider, or with
`openclaw models auth login --provider openai`. Add `--agent alhaitham` if the
credential should be local to that agent. Model selection still lives in Nix.

Thinking defaults live in Nix (`agents.defaults.thinkingDefault`). The chat
picker's available levels come from the selected model's reasoning profile; use
a reasoning model for the full set. The global "set for all agents" control
will fail in Nix mode by design.

Only then continue to Phase 5. Everything after this point can be fixed by
asking the agent you have just brought up.


# Phase 5 — put the data back

Copy the staging directory to macmini62 first:

~~~bash
rsync -a --info=progress2 \
  uzair@192.168.86.142:/home/uzair/backups/macmini62/staging/ ~/backup/
cd ~/backup
sha256sum -c SHA256SUMS | grep -v ': OK$'
ls -lh ~/backup
~~~

PostgreSQL roles and databases were created by the modules on the first switch.
Confirm before restoring:

~~~bash
sudo -u postgres psql -lqt | cut -d'|' -f1 | grep -E 'gitea|paperless'
~~~

## 5.1 Gitea

Target layout on NixOS, checked against the container's own app.ini
(WORK_PATH = /data/gitea, ROOT = /data/git/repositories,
APP_DATA_PATH = /data/gitea):

~~~text
/var/lib/gitea/repositories  <- gitea/git/repositories       (ROOT)
/var/lib/gitea/data          <- gitea/gitea/{avatars,repo-archive,
                                repo-avatars,packages,lfs,jwt,home}
/var/lib/gitea/custom        <- gitea/gitea/custom           (CUSTOM is
                                stateDir/custom, not stateDir/data)
drop                         <- gitea/gitea/conf/app.ini     (SECRET_KEY,
                                INTERNAL_TOKEN, JWT_SECRET, DB password)
~~~

Skip `gitea/ssh/` and `gitea/git/.ssh/`. They hold the container's built-in
SSH host keys and a delegated-mode authorized_keys, and the old instance had
`DISABLE_SSH = true` in its app.ini -- checked, not assumed -- so nothing ever
used them. The NixOS host enables Gitea SSH for the first time, on 2222, and
generates fresh host keys. Existing clones are https; ssh:// remotes start
working after the migration but need port 2222 in the URL.

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
OLD=/var/lib/gitea/restore/gitea
sudo install -d -o gitea -g gitea -m 0750 \
  /var/lib/gitea/repositories /var/lib/gitea/data /var/lib/gitea/custom
sudo cp -a "$OLD/git/repositories/." /var/lib/gitea/repositories/
for d in avatars repo-archive repo-avatars packages lfs jwt home; do
  [ -d "$OLD/gitea/$d" ] && sudo cp -a "$OLD/gitea/$d" /var/lib/gitea/data/
done
[ -d "$OLD/gitea/custom" ] && \
  sudo cp -a "$OLD/gitea/custom/." /var/lib/gitea/custom/
sudo chown -R gitea:gitea \
  /var/lib/gitea/repositories /var/lib/gitea/data /var/lib/gitea/custom
sudo rm -rf /var/lib/gitea/restore
~~~

Deliberately not copied: `conf/` (app.ini would override NixOS settings),
`sessions/`, `queues/`, `indexers/`, `tmp/`, `log/` -- runtime state that
is rebuilt on start.

Start and verify:

~~~bash
sudo systemctl start gitea
sudo journalctl -u gitea -n 40 --no-pager
curl -sI http://127.0.0.1:3001 | head -3
sudo -u gitea psql -d gitea -c 'select count(*) from repository;'
~~~

The count should match the number of repositories you had. NixOS runs Gitea as
`gitea`, not the container's `git` user; ownership must be `gitea:gitea`.

## 5.2 Paperless

Decision: no database restore. The old instance is paperless-ngx 2.12.1 and the
NixOS package is 3.1.3; rather than migrate across that major release, the 30
documents are re-ingested into a clean 3.1.3 instance. Tags, correspondents,
document types and titles beyond the filename do not carry over.

Kept from the old box, before the disk came out:

~~~text
~/backup/paperless-originals/   30 PDFs, renamed from the old id and title,
                                e.g. "0094 - CSC 656 Quiz 1.pdf"
~~~

Target layout, already created by the module:

~~~text
/var/lib/paperless/media     documents, written by Paperless
/var/lib/paperless/data      index and runtime state, written by Paperless
/var/lib/paperless/consume   drop zone, also the Samba "scans" share
~~~

The 2.12.1 media tree and SQL dump were not kept: neither can be loaded into
3.1.3, so the PDFs are the source of truth. If a document is missing after
re-ingest, compare against paperless-originals/, not against a dump.

The first switch starts an empty database, and `passwordFile` seeds the admin
account from the `paperless-admin-password` secret, so the login is already
the value in KeePass. There is no `changepassword` step.

Load the documents either over the network or through the share:

~~~bash
scp ~/backup/paperless-originals/*.pdf uzair@macmini62:/tmp/paperless-in/
~~~

or mount `smb://macmini62/scans` (guest, forced to paperless) and drag the
folder in. Then move them into consume:

~~~bash
sudo install -d -o paperless -g paperless -m 0775 /var/lib/paperless/consume
sudo mv /tmp/paperless-in/*.pdf /var/lib/paperless/consume/
sudo journalctl -u paperless -f | grep -i consume
~~~

Paperless polls consume, OCRs each file, and files it under
`{created_year}/{correspondent}/{title}` as set by
`PAPERLESS_FILENAME_FORMAT`. Thirty files is a few minutes on this hardware.
Watch the journal, not the UI, which lags behind.

Verify:

~~~bash
sudo -u paperless psql -d paperless -At -c 'select count(*) from documents_document;'
curl -sI http://127.0.0.1:28981 | head -3
~~~

30 documents. If one is missing, look for leftovers in
`/var/lib/paperless/consume/` and for a duplicate-checksum warning in the
journal: Paperless refuses a file whose hash it already has.

Tags and correspondents start empty. The old instance had 6 tags, 4
correspondents and 7 document types; recreate the ones still wanted.

Keep the tar and dump for 30 days. They are the only route back to the 2.12.1
metadata if the drag-drop turns out to have dropped something that mattered.

## 5.3 Minecraft

Target layout:

~~~text
/srv/minecraft/data      <- ./data     (world, server.properties, logs)
/srv/minecraft/mods      <- ./mods
/srv/minecraft/plugins   <- ./plugins
/srv/minecraft/config    <- ./config
~~~

Restore before the first successful container start. If the container starts
with an empty `/srv/minecraft/data`, it generates a fresh world that then has
to be replaced.

~~~bash
sudo install -d -o root -g root -m 0755 /srv/minecraft
sudo tar xzf ~/backup/minecraft.tar.gz -C /srv/minecraft --strip-components=1
sudo find /srv/minecraft -maxdepth 1 -mindepth 1 | sort
ls -l /srv/minecraft/data/world/level.dat
~~~

Expected: `config`, `data`, `mods`, `plugins`. If the archive has a different
root, list it first with `tar tzf ~/backup/minecraft.tar.gz | head` and adjust
the strip count.

**Mods.** minecraft.nix declares all 28 mods the world uses, by URL, at the same
versions as the jars in the archive: the two lists match name for name
(architectury, BiomesOPlenty, BuildingWands, cherry-monastery, cloth-config,
comforts, fabric-api, fabric-language-kotlin, FallingTree, ForgeConfigAPIPort,
GlitchCore, Jade, the nine mcw-* mods, PuzzlesLib, silk-all, TerraBlender,
travelersbackpack, veinminer, VisualWorkbench). data/mods is therefore
redundant; the image reinstalls the same set on start. Keeping it is harmless
and means a start with no network still has mods. Change the MODS list in
minecraft.nix rather than adding jars by hand.

The itzg image does not delete unlisted jars by default (REMOVE_OLD_MODS is
false), so the restored set and the declared set coexist. Both lists are the
same 28 mods at the same versions.


Check the jars before starting. A corrupt jar fails at mod discovery, not at
extract time:

~~~bash
sudo find /srv/minecraft/data/mods -name '*.jar' | while read -r f; do
  unzip -tqq "$f" >/dev/null 2>&1 || echo "BAD $f"
done
~~~

Delete any that report BAD; the image re-downloads them from the MODS list.


Ownership stays `root:root`; the itzg image runs as root and no PUID is set.

~~~bash
sudo systemctl start podman-minecraft
sudo journalctl -u podman-minecraft -f
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

## 5.6 OpenClaw conversation history

The gateway has been up since 4.7 and has been helping with the rest of this
phase. Conversation history is a separate, later restore, because it replaces a
live database.

Check the versions match first. The snapshot was taken on 2026.10.5; a different
schema on the new host is a one-way door.

~~~bash
openclaw --version
~~~

If they differ, stop here and keep the snapshot as an archive. Do not feed an
older agent database to a newer gateway.

~~~bash
systemctl --user stop openclaw-gateway
cd ~/.openclaw/agents/main/agent
cp openclaw-agent.sqlite openclaw-agent.sqlite.pre-restore
cp ~/backup/openclaw/agent-main.sqlite openclaw-agent.sqlite
chown uzair:users openclaw-agent.sqlite
systemctl --user start openclaw-gateway
sleep 20
openclaw status
~~~

Then look for the old sessions:

~~~bash
openclaw sessions list 2>/dev/null | head
~~~

The pre-restore file is the way back if the gateway refuses the database; delete
the restored one and rename it back.

Do not restore `state-openclaw.sqlite`. It carries gateway state, config
history and the old secret store, all of which the Nix config and agenix now
own; restoring it re-introduces values the declarative setup is replacing.

### Why openclaw.json is never restored

`hosts/macmini62/legacy/openclaw/openclaw.json` is imported at build time by
`openclaw.nix` (`lib.importJSON`), so its contents are baked into the Nix
store. The live `~/.openclaw/openclaw.json` is a different thing: the file the
old gateway wrote at runtime. Copying that onto the new host would put a stale,
host-specific config next to the module's, and the two disagree about the
gateway port, the secret sources and the auth profiles.

The committed snapshot was diffed against the live config before the migration:
they are identical except `gateway.auth.token`, which is deliberately replaced
by a SecretRef. If you change OpenClaw settings after cutover, change the JSON
in the repo and rebuild; runtime edits do not survive.

## 5.7 Ingress: tunnel for Gitea, tailnet for the rest

Decision: privacy first. Cloudflare terminates TLS at the edge, so anything
proxied through the tunnel is readable by Cloudflare. Gitea is the only public
name; the Home Assistant and Paperless UIs stay on the tailnet, where no third
party sees them and no port is open to the internet.

`tunnel.nix` declares the ingress and the connector runs as
`cloudflared-tunnel-macmini62`. The tunnel is locally managed, so DNS is the
missing half: it needs a CNAME, not a dashboard "public hostname". Add it in the
Cloudflare DNS tab:

~~~text
git.uzair.page  CNAME  c657b96e-5931-4c14-9290-28482f60794b.cfargotunnel.com  Proxied
~~~

Delete the old A records for casa, docs and git. Leave `mc.uzair.page` alone
for now; it is the one name that must bypass the proxy.

Serve the tailnet-only UIs:

~~~bash
sudo tailscale serve --bg --https=443  http://127.0.0.1:8123    # Home Assistant
sudo tailscale serve --bg --https=9443 http://127.0.0.1:28981   # Paperless
sudo tailscale serve status
~~~

8443 is already taken by the OpenClaw gateway, hence 9443. `serve` state lives
in `/var/lib/tailscale/tailscaled.state`, so it survives reboots without being
declared in the flake.

Then drop the router forwards for 80 and 443: the tunnel dials out and the
tailnet does not need them. Keep 25565 until Minecraft moves off the port
forward.

Verify:

~~~bash
systemctl status cloudflared-tunnel-macmini62 --no-pager | head -5
curl -sI https://git.uzair.page | head -3
curl -s -o /dev/null -w '%{http_code}\n' https://macmini62.tail9b9448.ts.net/
curl -s -o /dev/null -w '%{http_code}\n' https://macmini62.tail9b9448.ts.net:9443/
~~~

502 means the connector is up but the local service is not listening. 1033 means
the connector is not connected. A bare `curl -I` against Home Assistant returns
405, which is normal: it only answers GET.

Syncthing stays off both paths; the tailnet reaches it already.

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
| 3001 | Gitea HTTP | loopback only |
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
| Paperless documents | `paperless-originals/` (30 PDFs) | re-ingested via UI or the Samba `scans` share | paperless:paperless |
| Paperless database | none | created empty by the module | paperless |
| Minecraft | `minecraft.tar.gz` -> `data`, `mods`, `plugins`, `config` | `/srv/minecraft/...` | root:root |
| Home Assistant | `hass-config/` | `/var/lib/hass` | root:root |
| Matter fabric | `matter-server/` | `/var/lib/matter-server` | root:root |
| OpenClaw workspace | `openclaw/workspace.tar.gz` (no `openclaw.json`) | `/home/uzair/.openclaw` | uzair |
| OpenClaw history | `openclaw/agent-main.sqlite` | `~/.openclaw/agents/main/agent/` (5.6) | uzair |
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
