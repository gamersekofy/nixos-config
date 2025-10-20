{
  description = "Uzair's NixOS Configuration";

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
      url = "github:NixOS/nixos-hardware";
    };

    nixos-cli = {
      url = "github:water-sucks/nixos";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hyprland-qtutils = {
      url = "github:hyprwm/hyprland-qtutils";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
    };

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      precision-5530 = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.users.uzair = {
              imports = [
                ./hosts/precision-5530/home/home.nix
                inputs.catppuccin.homeModules.catppuccin
              ];
            };
          }

          ./hosts/precision-5530/system
          nixos-hardware.nixosModules.dell-precision-5530
        ];
      };

      macbookpro92 = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.users.uzair = {
              imports = [
                ./hosts/macbookpro92/home/home.nix
              ];
            };
          }

          ./hosts/macbookpro92/system
        ];
      };
    };
  };
}
