{
  home.file.".ssh/id_ed25519_sk_signing.pub".text = ''
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICV8xaw0idrjzIb/SjSWTdND6IHbyfL0uMS1lb0BdBXCAAAAD3NzaDpnaXQtc2lnbmluZw== YubiKey Git Signing Key
  '';

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
    };

    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519_sk_signing.pub";
    };
  };

  programs.git-credential-oauth = {
    enable = false;
  };
}
