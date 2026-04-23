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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cli = {
      url = "github:water-sucks/nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # rust-overlay.follows = "rust-overlay";
      };
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
    };

    tuxmanager = {
      url = "github:benapetr/TuxManager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    systemArch = "x86_64-linux";

    pkgsForSystem = import nixpkgs {
      system = systemArch;
      config = {
        allowUnfree = true;
        allowInsecurePredicate = pkg:
          builtins.elem (lib.getName pkg) [
            "broadcom-sta"
          ];
      };
    };
  in {
    nixosConfigurations = {
      precision-5530 = lib.nixosSystem {
        pkgs = pkgsForSystem;
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
              ];
            };
          }

          ./hosts/precision-5530/system
          nixos-hardware.nixosModules.dell-precision-5530
        ];
      };

      precision-5560 = lib.nixosSystem {
        pkgs = pkgsForSystem;
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
                ./hosts/precision-5560/home/home.nix
              ];
            };
          }

          ./hosts/precision-5560/system
          nixos-hardware.nixosModules.common-pc-laptop
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-cpu-intel
        ];
      };

      macbookpro92 = lib.nixosSystem {
        pkgs = pkgsForSystem;
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
