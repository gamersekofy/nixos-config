{inputs, ...}: {
  imports = [
    inputs.nixos-cli.nixosModules.nixos-cli
  ];
  programs.nixos-cli = {
    enable = true;
    settings = {
      aliases = {
        genlist = ["generation" "list"];
        switch = ["generation" "switch"];
        rollback = ["generation" "rollback"];
        gendel = ["generation" "delete"];
        gendelall = ["generation" "delete" "--all"];
        build = ["apply" "--no-activate" "--no-boot" "--output" "result"];
      };

      apply = {
        imply_impure_with_tag = true;
      };
    };
  };
}
