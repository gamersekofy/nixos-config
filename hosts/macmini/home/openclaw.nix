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

      # Todoist is a hosted MCP server, not a runtime plugin: no plugin entry.
      mcp.servers.todoist = {
        url = "https://ai.todoist.net/mcp";
        auth = "oauth";
        transport = "streamable-http";
      };

      plugins.entries = {
        "device-pair".config.publicUrl = "wss://macmini.tail9b9448.ts.net:8443";
      };
    };
  };
}
