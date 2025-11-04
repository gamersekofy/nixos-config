{pkgs, ...}: {
  # Enable and configure Git
  programs.git = {
    enable = true;
    settings = {
      aliases = {
        s = "status";
      };

      user = {
        name = "Uzair Mohammed";
        email = "uzair.hamed@gmail.com";
      };
      credential.helper = "store";
      init.defaultBranch = "master";
      core.autocrlf = true;
    };
  };

  programs.git-credential-oauth = {
    enable = false;
  };
}
