{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #minegrub-world-sel-theme = {
    #  url = "github:Lxtharia/minegrub-world-sel-theme";
    #};

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    nixos-cli = {
      url = "github:water-sucks/nixos";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    spicetify-nix,
    nixos-hardware,
    nixos-cli,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.users.uzair = {
              imports = [
                ./home/home.nix
              ];
            };
          }

          #inputs.minegrub-world-sel-theme.nixosModules.default

          nixos-hardware.nixosModules.dell-precision-5530

          nixos-cli.nixosModules.nixos-cli

          ./system
        ];
      };
    };
  };
}
