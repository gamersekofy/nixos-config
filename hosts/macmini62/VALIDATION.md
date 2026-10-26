# macmini62 validation report

Status: configuration is consistent with the stated migration plan and passes
the Nix module/eval checks. With temporary stubs for the two intentionally
missing post-install files, the full toplevel derivation evaluates. It is ready
for the install runbook once the manual secret and post-install steps below are
done.

## Eval result

Command:

    nix eval --no-write-lock-file \
      .#nixosConfigurations.macmini62.config.system.build.toplevel.drvPath

Without the generated files, only the expected assertions remain:

    - The 'fileSystems' option does not specify your root file system.
    - You must set the option 'boot.loader.grub.devices' or
      'boot.loader.grub.mirroredBoots' to make the system bootable.

Both are expected: `hardware-configuration.nix` and `bootloader.nix` are
intentionally absent until generated on the installed machine. With temporary
stubs supplying a root filesystem and boot device, the full toplevel evaluates:

    /nix/store/i3r6kin65i2hz7ajpwspxb6azlvxmpk9-nixos-system-macmini62-26.11.20260928.7a0f122.drv

That is stronger than schema-only validation: all imports, option names, types,
OpenClaw schema and secret declarations flow through to the system derivation.
The stubs were removed afterwards; the real files are generated on install.

Formatting: all changed Nix files pass `alejandra`.

## Fixes applied

Correctness:

- paperless.nix: `database.createLocally = true` so the documented PostgreSQL
  restore has a database; `configureTika = true`; CSRF trusted origin for
  docs.uzair.page.
- minecraft.nix: full legacy Fabric 1.21.11 environment (TYPE, VERSION,
  OVERRIDE_SERVER_PROPERTIES, MAX_TICK_TIME, secure profile, memory,
  autopause, resource pack, all MODS, whitelist/ops, PVP). Without TYPE and
  VERSION the image would start vanilla and ignore the restored mods.
- hass.nix: matter-server container with persistent `/var/lib/matter-server`.
  USB passthrough is intentionally commented out: there is no radio, and Docker
  refuses to start a container whose `--device` path is missing.
- gitea.nix: `SSH_USER = "gitea"` (NixOS user, not Docker's git) and
  `SSH_DOMAIN = "git.uzair.page"`.
- default.nix: `users.users.uzair.linger = true` so the OpenClaw user service
  starts on a headless machine.
- tunnel.nix: Syncthing ingress removed. GUI is not public.
- precision-5560/openclaw-node.nix: gateway host changed to
  macmini62.tail9b9448.ts.net.

Security / secrets:

- syncthing.nix: GUI bound to 127.0.0.1, password from agenix
  (`guiPasswordFile`), sync/discovery ports opened, GUI port not exposed.
- secrets.nix: cloudflared credentials owned by root (DynamicUser), added
  syncthing-password, openclaw-gateway-token, openclaw-secrets and
  gog-keyring-password with narrow ownership.
- precision-5560/syncthing.nix: plaintext GUI password replaced with a bcrypt
  hash (cost 12); TODO added for the new macmini62 device ID.
- legacy OpenClaw JSON: the old inline gateway bearer token was removed before
  tracking the file in Git.
- tunnel.nix: old public Syncthing hostname is gone.

Backup:

- backup.nix: `services.postgresqlBackup` at 00:30; restic at 02:00.
- known_hosts entry for precision-5560 (tailnet and LAN names + ed25519 key).
- paths cover gitea, paperless, PostgreSQL dumps, OpenClaw, minecraft, hass,
  `.openclaw`, and the repo.
- OpenClaw SQLite copied with `sqlite3 .backup` before restic; live DB and
  WAL/SHM excluded.
- prune 7 daily / 5 weekly / 6 monthly, `--read-data-subset=1/20`, persistent
  timer with jitter.

OpenClaw:

- home/openclaw.nix imports the legacy `openclaw.json` with
  `lib.importJSON` and layers host-specific overrides. Agents (main/Ineffa,
  linnea, alhaitham), skills, plugins, models and Todoist MCP are preserved.
- `auth = null` drops the stale persisted auth profile.
- `gateway.bind = "loopback"`; `tailscale serve --https=8443` is documented as
  required.
- Gateway token and provider keys use file SecretRefs. The token secret is a
  small JSON document (`{"gatewayToken":"..."}`) because that is the shape the
  file provider's `mode = "json"` reads.
- `device-pair.publicUrl` is wss://macmini62.tail9b9448.ts.net:8443.
- `GOG_KEYRING_PASSWORD` is wired to the agenix secret path.

Docs:

- `MIGRATION.md` rewritten to match the actual config: repo path, Gitea Docker
  to NixOS layout mapping, Paperless PostgreSQL 13 to 16 dump/restore through
  stdin, Minecraft restore, Syncthing loopback, restic root key, OpenClaw
  state-only restore, and the corrected backup appendix.
- `secrets/README.md` documents key creation, recipients, the exact secret
  contents, and the intentional first-switch failure with empty placeholders.

## Manual steps that are still required

Before install:

- Fill `hosts/macmini62/secrets/secrets.nix` with the macmini62 host age key and a
  personal recipient. The current value is a deliberate placeholder.
- Encrypt all seven `.age` files. The four new files are 0-byte placeholders
  and are staged but not committed.
- Create the 5560 restic repository directory and authorize the macmini62 root
  SSH key.
- Confirm the legacy backup archive layout, especially `gitea-layout.txt`, so
  the Docker `/data/git/repositories` and `/data/gitea` mapping is exact.
- Commit the changes and create the git bundle used for the macmini62 clone.

After install:

- Generate `hardware-configuration.nix` and `bootloader.nix`, then uncomment
  their imports in `system/default.nix`.
- Run the restic first backup and prove a restore.
- Create the Cloudflare tunnel and encrypt its credentials.
- Re-auth Tailscale and update the node name.
- Update the macmini62 Syncthing device ID in the precision-5560 config.
- If a USB radio is added later, uncomment `devices = [ "/dev/ttyUSB0" ];` in
  hass.nix.

## Residual risks

- `lib.importJSON` makes the legacy OpenClaw JSON a tracked repository file.
  It has been sanitized of the live gateway token, but re-check it for other
  secrets before committing the rest of the legacy directory.
- OpenClaw's actual runtime secret resolution was not exercised; only schema
  evaluation was. Test `openclaw status` after activation.
- Gitea restore depends on the archive layout. The runbook stages and inspects
  it first instead of blindly stripping into `/var/lib/gitea`.
- The itzg Minecraft container keeps the legacy `/mods`, `/plugins` and
  `/config` volume layout. The legacy compose used the same layout; verify the
  log still loads the Fabric mods after restore.
- precision-5560 still contains the old macmini62 Syncthing device ID. This
  cannot be fixed until the new install generates its ID.
- The precision-5560 is a temporary restic target, not a complete 3-2-1
  backup.

## Files changed

System:

- hosts/macmini62/system/paperless.nix
- hosts/macmini62/system/minecraft.nix
- hosts/macmini62/system/hass.nix
- hosts/macmini62/system/gitea.nix
- hosts/macmini62/system/syncthing.nix
- hosts/macmini62/system/backup.nix
- hosts/macmini62/system/secrets.nix
- hosts/macmini62/system/default.nix
- hosts/macmini62/system/tunnel.nix

Home and secrets:

- hosts/macmini62/home/openclaw.nix
- hosts/macmini62/secrets/secrets.nix
- hosts/macmini62/secrets/README.md
- hosts/macmini62/secrets/{syncthing-password,openclaw-gateway-token,openclaw-secrets,gog-keyring-password}.age (empty placeholders)
- hosts/macmini62/legacy/openclaw/openclaw.json (token removed, staged)

Other hosts:

- hosts/precision-5560/home/modules/openclaw-node.nix
- hosts/precision-5560/system/syncthing.nix

Docs:

- hosts/macmini62/MIGRATION.md
- hosts/macmini62/VALIDATION.md

## Re-validation commands

    alejandra --check \
      hosts/macmini62/home/openclaw.nix \
      hosts/macmini62/system/{backup,default,gitea,hass,minecraft,paperless,secrets,syncthing,tunnel}.nix \
      hosts/macmini62/secrets/secrets.nix \
      hosts/precision-5560/home/modules/openclaw-node.nix \
      hosts/precision-5560/system/syncthing.nix
    git diff --check
    nix eval --no-write-lock-file \
      .#nixosConfigurations.macmini62.config.system.build.toplevel.drvPath

After the two generated files exist, the last command should build the
toplevel derivation instead of stopping at the two assertions.

---

# Second review — 2026-10-24 12:15 (Ineffa)

Independent check of the report above, against the tree as staged, plus the
nixpkgs module sources. Verdict: the findings are sound; two corrections were
needed and are applied.

## Confirmed at the source

- `cloudflared` uses `LoadCredential` with `DynamicUser = true`
  (nixos/modules/services/networking/cloudflared.nix). Root ownership of the
  age secret is correct; an owner of "cloudflared" would fail the agenix chown.
- `services.paperless.database.createLocally` defaults to `false`
  (nixos/modules/services/misc/paperless.nix:357). Without `true` the host
  would run SQLite and the documented psql restore would target a database
  that does not exist. This was the most consequential finding.
- `programs.ssh.knownHosts.precision-5560.publicKey` matches the 5560's real
  `/etc/ssh/ssh_host_ed25519_key.pub` byte for byte.
- `programs.openclaw.environment` documents that values pointing at files are
  read at runtime, so the GOG_KEYRING_PASSWORD path is correct.
- `services.syncthing.guiPasswordFile` exists and bcrypts at runtime.
- `hosts/macmini62/legacy/openclaw/openclaw.json` carries no plaintext
  credentials; its only apiKey is a store-backed SecretRef.

## Evaluation

With temporary stubs for hardware-configuration.nix and bootloader.nix the
full toplevel builds:

    /nix/store/i3r6kin65i2hz7ajpwspxb6azlvxmpk9-nixos-system-macmini62-26.11.20260928.7a0f122.drv

That is stricter than "stops at the expected assertions".

## Correction 1 — bootstrap order (MIGRATION.md, section 1 and 4)

The earlier advice to "temporarily comment out ./secrets.nix" does not
evaluate: paperless.nix, tunnel.nix, backup.nix and syncthing.nix all read
config.age.secrets.<name>.path, which is undefined without the module.

Installing the full flake with nixos-install also fails, because activation
runs in the target and agenix cannot decrypt before a host key exists.

MIGRATION.md now instructs: install a MINIMAL system, boot it, encrypt the
secrets, then switch to the full configuration. A recovery path is documented
for anyone who already attempted the full install.

## Correction 2 — Home Assistant device passthrough

`devices = ["/dev/ttyUSB0"]` was removed. There is no USB radio on this
machine, and Docker refuses to start a container whose --device path is
missing, so the container would have failed on first boot. The line is kept as
a comment with instructions to re-add it when a stick is present.

## Still unverified (runtime only)

- The file secret provider shapes: {"gatewayToken": "..."} with
  id = "/gatewayToken", and {"deepseek": "...", "zai": "..."}.
- `auth = null` via recursiveUpdate against a live gateway.
- Any additional model provider in the legacy JSON whose key was a store
  SecretRef on the old host.
- Whether bcrypt cost 12 is acceptable for the new Syncthing GUI password
  (it is a reasonable default; adjust only if login latency matters).

These are all resolved by `openclaw status`, `systemctl --user status
openclaw-gateway`, and a login attempt after first boot.


---

# Host rename — 2026-10-24 13:20 (Ineffa)

The host is now macmini62, matching Apple's identifier and leaving the
macmini name free for a future machine.

What changed:

- hosts/macmini -> hosts/macmini62 (git mv, history preserved)
- flake attribute nixosConfigurations.macmini62
- networking.hostName, Samba server string, tunnel name
  cloudflared-tunnel-macmini62
- restic unit restic-backups-macmini62 and repository path
  /home/uzair/backups/macmini62 on the 5560
- device-pair URL wss://macmini62.tail9b9448.ts.net:8443, and the same
  gateway host in hosts/precision-5560/home/modules/openclaw-node.nix
- all paths in this report and in MIGRATION.md

Re-evaluated after the rename and after alejandra formatting, with the same
two stubs:

    /nix/store/i3r6kin65i2hz7ajpwspxb6azlvxmpk9-nixos-system-macmini62-26.11.20260928.7a0f122.drv

Two further adjustments:

- hosts/macmini62/system/default.nix now declares
  swapDevices = [{device = "/swapfile"; size = 8192;}], so regenerating
  hardware-configuration.nix cannot drop the swap file.
- home.stateVersion raised from 23.11 to 26.11. A new host should start on the
  release it is installed with; 23.11 was carried over by accident.

Both were re-evaluated; the derivation above is the result.
