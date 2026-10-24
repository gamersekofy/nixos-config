{lib, ...}: let
  # Ported from the legacy ~/.openclaw/openclaw.json. Keeping the JSON as the
  # base preserves the agents, skills, plugins and model policy exactly; the
  # overrides below replace host-specific values and inline secrets.
  legacy = lib.importJSON ../legacy/openclaw/openclaw.json;

  config = lib.recursiveUpdate legacy {
    # The old setup used a persisted auth profile. Provider API keys now come
    # from the file secret provider below, so drop the stale profile.
    auth = null;

    gateway = {
      # tailscale serve proxies 8443 -> loopback.
      bind = "loopback";
      auth.token = {
        source = "file";
        provider = "gatewayToken";
        id = "/gatewayToken";
      };
    };

    secrets.providers = {
      agenix = {
        source = "file";
        path = "/run/agenix/openclaw-secrets";
        mode = "json";
      };

      gatewayToken = {
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
    };
  };
in {
  # nix-openclaw reads file-backed environment values at runtime.
  programs.openclaw = {
    enable = true;
    environment.GOG_KEYRING_PASSWORD = "/run/agenix/gog-keyring-password";
    inherit config;
  };
}
