{
  imports = [
    ./ssh.nix
  ];

  programs.ssh = {
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_sk_rk_github-auth_gamersekofy";
      };
    };
  };

  home.file.".ssh/id_ed25519_sk_rk_git-signing_gamersekofy.pub".text = ''
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
      key = "~/.ssh/id_ed25519_sk_rk_git-signing_gamersekofy.pub";
    };
  };

  programs.git-credential-oauth = {
    enable = false;
  };
}
