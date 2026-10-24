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
    domain = "git.uzair.page";
    rootUrl = "https://git.uzair.page/";
    httpPort = 3000;
    stateDir = "/var/lib/gitea";
    repositoryRoot = "/var/lib/gitea/repositories";
    lfs.enable = true;

    settings = {
      server = {
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
