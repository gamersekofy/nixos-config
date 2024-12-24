{ pkgs, ... }: 
{
  # Enable and configure Git
  programs.git = {
    enable = true;
    aliases = {
      s = "status";
    };
    userName = "Uzair Mohammed";
    userEmail = "uzair.hamed@gmail.com";
    extraConfig = {
      credential.helper = "store";
      init.defaultBranch = "master";
    };
  };

  programs.git-credential-oauth = {
    enable = false;
  };
}
