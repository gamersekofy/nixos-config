{lib, pkgs, ...}: let
  # Ported from the legacy ~/.openclaw/openclaw.json. Keeping the JSON as the
  # base preserves the agents, skills, plugins and model policy exactly; the
  # overrides below replace host-specific values and inline secrets.
  legacy = lib.importJSON ../legacy/openclaw/openclaw.json;

  # Remove plugin entries that this host must not carry. WhatsApp is not used at
  # all here, and nix-openclaw does not package the Todoist plugin: the Todoist
  # MCP server is configured natively under mcp.servers instead. Leaving either
  # entry in place only produces "plugin not found" warnings at startup.
  base = legacy // {
    plugins = legacy.plugins // {
      entries = lib.removeAttrs legacy.plugins.entries [ "whatsapp" "todoist" ];
    };
  };

  config = lib.recursiveUpdate base {
    # The old setup used a persisted auth profile. Provider API keys now come
    # from the file secret provider below, so drop the stale profile.
    auth = null;

    # Miko: Entertainment agent. Sibling workspace, own memory, and no
    # execution, messaging, mail, calendar or MCP tools - she can only read and
    # write inside her own workspace. thinkingDefault stays off by request.
    agents.entries.miko = {
      name = "Miko";
      workspace = "/home/uzair/.openclaw/workspace-miko";
      agentDir = "/home/uzair/.openclaw/agents/miko/agent";
      model = "deepseek/deepseek-flash";
      thinkingDefault = "off";
      identity = {
        name = "Yae Miko";
        emoji = "🦊";
        avatar = "avatars/Miko.png";
      };
      tools = {
        profile = "minimal";
        alsoAllow = [ "group:fs" "view_image" "group:memory" ];
        deny = [ "gateway" ];
      };
    };

    # Alhaitham: coursework repos live outside his agent workspace, under
    # /home/uzair/Projects. OpenClaw has no per-directory allowlist - the only
    # boundary is the per-agent workspace jail - and his exec already reaches
    # the whole host, so lift the file-tool jail for this agent only. This makes
    # read/write/edit/apply_patch usable on absolute paths outside the
    # workspace; other agents stay jailed.
    agents.entries.alhaitham.tools = {
      fs.workspaceOnly = false;
      exec.applyPatch.workspaceOnly = false;
    };

    # Playwright drives this over CDP on port 18800. The store path is used
    # directly: without it Playwright downloads its own browser, which expects
    # FHS paths (/lib64, /usr/lib) that do not exist on NixOS. Headless is the
    # only mode here - the host has no DISPLAY.
    browser = {
      enabled = true;
      executablePath = "${pkgs.chromium}/bin/chromium";
      headless = true;
      noSandbox = true;
    };

    gateway = {
      # tailscale serve proxies 8443 -> loopback.
      bind = "loopback";
      auth.token = {
        source = "file";
        provider = "gateway-token";
        id = "/gatewayToken";
      };
    };

    # Newer OpenClaw builds archive visible dashboard sessions after seven
    # days without activity. Keep conversations until they are archived by
    # hand instead of having the sidebar empty itself.
    session.maintenance.archiveDashboardAfter = false;

    secrets.providers = {
      agenix = {
        source = "file";
        path = "/run/agenix/openclaw-secrets";
        mode = "json";
      };

      "gateway-token" = {
        source = "file";
        path = "/run/agenix/openclaw-gateway-token";
        mode = "json";
      };
    };

    models.providers = {
      deepseek.apiKey = {
        source = "file";
        provider = "agenix";
        id = "/deepseek";
      };
      zai.apiKey = {
        source = "file";
        provider = "agenix";
        id = "/zai";
      };
    };

    plugins.entries = {
      "device-pair".config.publicUrl = "wss://macmini62.tail9b9448.ts.net:8443";

      typesafe.config.apiKey = {
        source = "file";
        provider = "agenix";
        id = "/typesafe";
      };
    };
  };
in {
  # nix-openclaw reads file-backed environment values at runtime.
  programs.openclaw = {
    enable = true;
    environment.GOG_KEYRING_PASSWORD = "/run/agenix/gog-keyring-password";
    inherit config;

    # Official external plugins, packaged immutably by nix-openclaw.
    runtimePlugins = [
      "codex"
      "deepseek"
      "typesafe"
      "zai"
    ];
  };

  systemd.user.services.openclaw-gateway.Install.WantedBy = ["default.target"];
}
