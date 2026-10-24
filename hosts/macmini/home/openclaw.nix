{
  # nix-openclaw, Golden Path 2: Gateway as a user service on the tailnet.
  # Nix mode disables openclaw plugins install; declare plugins here.
  programs.openclaw = {
    enable = true;

    config = {
      gateway = {
        bind = "tailnet";
        port = 18789;
        trustedProxies = ["127.0.0.1"];
      };

      mcp.servers.todoist = {
        url = "https://ai.todoist.net/mcp";
        auth = "oauth";
        transport = "streamable-http";
      };

      plugins.entries = {
        todoist.enabled = true;
        "device-pair".config.publicUrl = "wss://macmini.tail9b9448.ts.net:8443";
      };
    };

    # Confirm the plugin id first:
    #   jq -r '.supported[].id' nix/generated/openclaw-runtime-plugins/report.json
    # If absent, use runtimePluginSources instead:
    # runtimePluginSources = [{ id = "todoist"; spec = "npm:@openclaw/todoist@<version>"; }];
    # runtimePlugins = ["todoist"];
  };
}
