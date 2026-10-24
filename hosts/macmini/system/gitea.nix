{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = ["gitea"];
    ensureUsers = [
      {
        name = "gitea";
        ensureDBOwnership = true;
      }
    ];
  };

  services.gitea = {
    enable = true;
    database.type = "postgres";
    database.socket = "/run/postgresql";
    stateDir = "/var/lib/gitea";
    repositoryRoot = "/var/lib/gitea/repositories";
    lfs.enable = true;

    settings = {
      server = {
        DOMAIN = "git.uzair.page";
        ROOT_URL = "https://git.uzair.page/";
        # Loopback only: the Cloudflare Tunnel is the sole ingress.
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
        START_SSH_SERVER = true;
        SSH_PORT = 2222;
        SSH_LISTEN_PORT = 2222;
      };
      service = {
        DISABLE_REGISTRATION = true;
        REQUIRE_SIGNIN_VIEW = true;
      };
      repository.DEFAULT_BRANCH = "main";
    };
  };
}
