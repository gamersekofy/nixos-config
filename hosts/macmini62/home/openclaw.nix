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
