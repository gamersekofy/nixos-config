{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.openclaw-node;

  openclawNodePackage =
    (pkgs.openclawPackages.withTools {
      toolNamesOverride = [];
    }).openclaw;
in {
  options.programs.openclaw-node = {
    enable = lib.mkEnableOption "OpenClaw node host";

    gatewayHost = lib.mkOption {
      type = lib.types.str;
      description = "Hostname or address of the existing OpenClaw Gateway.";
      example = "gateway.tailnet.example";
    };

    gatewayPort = lib.mkOption {
      type = lib.types.port;
      default = 18789;
      description = "WebSocket port of the OpenClaw Gateway.";
    };

    tls = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether the Gateway connection uses TLS.";
    };

    displayName = lib.mkOption {
      type = lib.types.str;
      default = config.home.username;
      description = "Name shown for this node in the Gateway.";
    };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.openclaw";
      description = "Directory containing node identity and pairing state.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      openclawNodePackage
    ];

    systemd.user.services.openclaw-node = {
      Unit = {
        Description = "OpenClaw node host";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };

      Service = {
        ExecStart = lib.concatStringsSep " " (
          [
            "${openclawNodePackage}/bin/openclaw"
            "node"
            "run"
            "--host"
            (lib.escapeShellArg cfg.gatewayHost)
            "--port"
            (toString cfg.gatewayPort)
          ]
          ++ lib.optional cfg.tls "--tls"
          ++ [
            "--display-name"
            (lib.escapeShellArg cfg.displayName)
          ]
        );

        Environment = [
          "OPENCLAW_STATE_DIR=${cfg.stateDir}"
        ];

        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
