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
      url = "github:NixOS/nixos-hardware/893d255bed44d251e84e90fad25e7ad5f45cf117";
    };

    nixos-cli = {
      url = "github:water-sucks/nixos";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    spicetify-nix,
    nixos-hardware,
    nixos-cli,
    lanzaboote,
    nixvim,
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
                nixvim.homeManagerModules.nixvim
              ];
            };
          }

          #inputs.minegrub-world-sel-theme.nixosModules.default

          nixos-hardware.nixosModules.dell-precision-5530

          nixos-cli.nixosModules.nixos-cli

          lanzaboote.nixosModules.lanzaboote
 
          ./system
        ];
      };
    };
  };
}
