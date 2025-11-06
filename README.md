# NixOS Configuration

A comprehensive NixOS configuration for multiple systems, built with Nix Flakes and Home Manager. This repository manages configurations for a Dell Precision 5530 laptop and a mid-2012 MacBook Pro, featuring extensive customization for development workflows, desktop environments, and system services.

## Overview

This configuration is designed to be both a practical daily-driver setup and a reference implementation for NixOS users. It demonstrates advanced patterns for multi-host management, modular configuration organization, and integration of modern tooling.

## Hardware

### Dell Precision 5530 (`precision-5530`)
- Primary workstation with full desktop environment
- Secure Boot support via Lanzaboote
- KDE Plasma 6 desktop environment
- GPU screen recording capabilities
- Syncthing synchronization
- Thunderbolt support
- Steam gaming setup
- Virtualization (QEMU/KVM)

### MacBook Pro Mid 2012 (`macbookpro92`)
- Legacy hardware support via nixos-hardware
- Broadcom wireless drivers
- macOS-specific optimizations (mbpfan)
- KDE Plasma 6 desktop environment
- Custom graphics configuration

## Repository Structure

```
.
├── flake.nix                    # Main flake configuration
├── flake.lock                   # Locked dependency versions
└── hosts/
    ├── common/                  # Shared configurations
    │   ├── home/               # Common Home Manager modules
    │   │   ├── dev/            # Development tools
    │   │   ├── media/          # Media applications
    │   │   ├── misc/           # Miscellaneous utilities
    │   │   ├── social/         # Communication apps
    │   │   └── wm-utils/       # Window manager utilities
    │   ├── system/             # Common system modules
    │   └── wallpapers/         # Shared wallpapers
    ├── precision-5530/         # Dell Precision configuration
    │   ├── home/               # User-specific home config
    │   └── system/             # System-specific config
    └── macbookpro92/           # MacBook Pro configuration
        ├── home/               # User-specific home config
        └── system/             # System-specific config
```

## Key Features

### Development Environment

#### Editors
- **Helix**: Primary terminal editor with LSP support for Rust, Nix, and more
  - Clippy integration for Rust
  - nixd language server for Nix
  - Custom themes and configuration
  - crates-lsp for Cargo.toml management

- **Zed**: Modern GUI editor with extensions
  - Nix, C#, LaTeX support
  - Catppuccin theme integration
  - Git Firefly extension

#### Shell & CLI Tools
- **Fish Shell**: Default shell with custom functions and abbreviations
  - Z directory jumper
  - Git abbreviations
  - Custom gitignore fetcher
  - Nix flake template initializer

- **Starship**: Customized shell prompt
- **Eza**: Modern ls replacement with icons
- **Bat**: Syntax-highlighted cat alternative
- **Yazi**: Terminal file manager
- **direnv**: Automatic environment switching

#### Version Control
- Git with custom configuration
- GitHub CLI integration

### Desktop Environments & Window Managers

#### KDE Plasma 6
- Full desktop environment on both systems
- KDE Connect for device integration
- Custom theme configurations
- Partition Manager
- Filelight disk usage analyzer

#### Niri (Available)
- Scrollable-tiling Wayland compositor
- Alternative window manager option
- SDDM integration

#### Hyprland (Available)
- Dynamic tiling Wayland compositor
- Configured with Cachix binary cache
- Commented out by default for easy switching

### Theming

#### GTK Themes
- Catppuccin Mocha (Red accent)
- Papirus icon theme with Catppuccin colors
- Custom cursor theme (Furina-v2)

#### KDE Themes
- Catppuccin integration
- Consistent theming across applications

### Media & Entertainment

- **Spotify**: Via Spicetify for customization
- **OBS Studio**: For screen recording and streaming
- **Minecraft**: Gaming setup
- **Steam**: Gaming platform (precision-5530 only)
- **GPU Screen Recorder**: Hardware-accelerated recording

### Communication

- **Discord**: Via nixcord for customization
- Custom social app configurations

### System Services

#### Syncthing (precision-5530)
- Automatic file synchronization
- Configured devices: Phone and Mac Mini server
- Synchronized folders: Music, Secrets, Resumable snapshots
- Web GUI with authentication

#### Display Manager
- SDDM with KDE Plasma integration
- Custom configuration per host

#### Audio
- PipeWire with WirePlumber
- Full audio stack replacement

#### Power Management
- Custom power profiles
- Laptop-specific optimizations
- mbpfan for MacBook thermal management

#### Security
- Yubikey support
- Secure Boot (Lanzaboote on precision-5530)
- Hardware security module integration

### Wayland Utilities

- **Waybar**: Status bar for Wayland compositors
- **Mako/SwayNC**: Notification daemons
- **wlogout**: Logout menu
- **wlsunset**: Automatic color temperature adjustment
- **Cliphist/Clipse**: Clipboard managers
- **Alacritty/Kitty**: Terminal emulators
- **udiskie**: Automatic disk mounting

### Virtualization

- QEMU/KVM setup (precision-5530)
- virt-manager with automatic connection
- dconf integration for VM settings

## Installation

### Prerequisites

- NixOS installed on target hardware
- Nix Flakes enabled in your configuration or via:
  ```nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  ```

### Clone the Repository

```bash
git clone https://github.com/gamersekofy/nixos-config.git
cd nixos-config
```

### Build Configuration

For the Dell Precision 5530:
```bash
sudo nixos-rebuild switch --flake .#precision-5530
```

For the MacBook Pro:
```bash
sudo nixos-rebuild switch --flake .#macbookpro92
```

### Test Configuration (Without Switching)

```bash
sudo nixos-rebuild test --flake .#precision-5530
```

### Build Without Activating

```bash
nixos-rebuild build --flake .#precision-5530
```

## Flake Structure

The flake configuration (`flake.nix`) follows a modular approach:

### Inputs

Key dependencies include:
- `nixpkgs`: NixOS unstable channel
- `home-manager`: Declarative dotfile management
- `nixos-hardware`: Hardware-specific configurations
- `spicetify-nix`: Spotify theming
- `lanzaboote`: Secure Boot support
- `rust-overlay`: Rust toolchain management
- `nixvim`: Neovim distribution
- `hyprland`: Wayland compositor
- `niri`: Scrollable tiling compositor
- `nixcord`: Discord customization
- `catppuccin`: Theme integration

### Outputs

Defines two NixOS system configurations:
- `precision-5530`: Full-featured workstation
- `macbookpro92`: Legacy hardware configuration

Both systems use:
- Home Manager for user-level configuration
- Shared `common` modules for consistent experience
- Host-specific overrides in `hosts/<hostname>/`

### Unfree and Insecure Packages

The configuration allows:
- Unfree packages globally
- Specific insecure packages (broadcom-sta for MacBook WiFi)

## Customization Guide

### Adding a New Host

1. Create a new directory in `hosts/`:
   ```bash
   mkdir -p hosts/my-machine/{home,system}
   ```

2. Add system configuration in `hosts/my-machine/system/default.nix`:
   ```nix
   {
     imports = [
       ./hardware-configuration.nix
       ../../common/system/tzLocale.nix
       # Add other common modules
     ];
   }
   ```

3. Add home configuration in `hosts/my-machine/home/home.nix`:
   ```nix
   { config, pkgs, inputs, ... }:
   {
     imports = [
       # Import modules as needed
     ];
     
     home.username = "your-username";
     home.homeDirectory = "/home/your-username";
     home.stateVersion = "24.05";
     programs.home-manager.enable = true;
   }
   ```

4. Add to `flake.nix`:
   ```nix
   nixosConfigurations.my-machine = lib.nixosSystem {
     pkgs = pkgsForSystem;
     specialArgs = {inherit inputs;};
     modules = [
       home-manager.nixosModules.home-manager
       {
         home-manager.extraSpecialArgs = {inherit inputs;};
         home-manager.useGlobalPkgs = true;
         home-manager.useUserPackages = true;
         home-manager.backupFileExtension = "backup";
         
         home-manager.users.your-username = {
           imports = [
             ./hosts/my-machine/home/home.nix
           ];
         };
       }
       ./hosts/my-machine/system
     ];
   };
   ```

### Switching Desktop Environments

To switch from KDE Plasma to Hyprland:

1. In `hosts/<hostname>/system/default.nix`:
   ```nix
   imports = [
     # ...
     # ../../common/system/kdePlasma.nix  # Comment out
     ../../common/system/hyprland.nix      # Uncomment
   ];
   ```

2. Rebuild your system:
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

### Adding New Packages

For system-wide packages, edit `hosts/<hostname>/system/miscNixStuff.nix` or appropriate module.

For user packages, edit `hosts/<hostname>/home/modules/` or use:
```nix
home.packages = with pkgs; [
  your-package
];
```

### Modifying Shared Configurations

Common configurations in `hosts/common/` affect all systems. Edit these carefully:
- `common/home/dev/`: Development tool configurations
- `common/system/`: System-level services and settings

## Notable Configuration Patterns

### Modular Home Manager Organization

This configuration demonstrates clean separation:
- Development tools in `dev/`
- Media applications in `media/`
- Window manager utilities in `wm-utils/`
- Misc utilities in `misc/`

Each module is self-contained and can be imported independently.

### Language Server Protocol (LSP) Configuration

The Helix and Zed configurations show how to properly integrate LSPs:
```nix
language-server.nixd = {
  command = "${pkgs.nixd}/bin/nixd";
};
```

This pattern ensures LSP servers are available in the environment.

### Theme Consistency

Demonstrates Catppuccin theme integration across:
- GTK applications
- KDE Plasma
- Terminal applications (Helix, Bat, Yazi)
- Editors (Zed, Helix)

### Hardware-Specific Overrides

Shows how to handle different hardware requirements:
- Broadcom WiFi on MacBook via allowInsecurePredicate
- Dell-specific modules from nixos-hardware
- GPU-specific configurations

### Secure Boot with Lanzaboote

The precision-5530 configuration shows Secure Boot setup:
```nix
boot.lanzaboote = {
  enable = true;
  pkiBundle = "/etc/secureboot";
};
```

### Syncthing Declarative Configuration

Demonstrates complete Syncthing setup with devices and folders:
```nix
services.syncthing = {
  enable = true;
  user = "uzair";
  overrideDevices = true;
  overrideFolders = true;
  settings = {
    devices = { /* ... */ };
    folders = { /* ... */ };
  };
};
```

## Useful Commands

### Update Flake Inputs

```bash
nix flake update
```

### Update Specific Input

```bash
nix flake lock --update-input nixpkgs
```

### Check Flake

```bash
nix flake check
```

### Show Flake Outputs

```bash
nix flake show
```

### Garbage Collection

```bash
# Delete old generations
sudo nix-collect-garbage -d

# Delete generations older than 30 days
sudo nix-collect-garbage --delete-older-than 30d
```

### List Generations

```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Rollback to Previous Generation

```bash
sudo nixos-rebuild switch --rollback
```

## Advanced Topics

### Binary Caches

This configuration uses several binary caches to speed up builds:
- Hyprland Cachix
- Walker Cachix
- Default NixOS cache

### Home Manager Backup Extension

Configured with `backupFileExtension = "backup"` to preserve existing dotfiles during first activation.

### Following Inputs

The flake uses `inputs.nixpkgs.follows = "nixpkgs"` pattern to ensure all dependencies use the same nixpkgs version, reducing duplication and improving reproducibility.

## Troubleshooting

### Rebuild Fails

1. Check for syntax errors:
   ```bash
   nix flake check
   ```

2. Try building without switching:
   ```bash
   sudo nixos-rebuild build --flake .#<hostname>
   ```

3. Check logs:
   ```bash
   journalctl -xeu nixos-rebuild
   ```

### Home Manager Issues

1. Remove backup files if conflicts occur:
   ```bash
   rm ~/.config/file.backup
   ```

2. Force rebuild:
   ```bash
   home-manager switch --flake .#uzair@<hostname>
   ```

### Disk Space Issues

NixOS can accumulate old generations. Clean up with:
```bash
sudo nix-collect-garbage -d
sudo nixos-rebuild switch --flake .#<hostname>
```

## Contributing

This repository is personal configuration but welcomes:
- Bug reports for configuration errors
- Suggestions for better patterns
- Questions about specific setups

When suggesting changes:
1. Test on your own system first
2. Ensure changes don't break existing functionality
3. Follow the existing modular structure
4. Document new patterns or unusual configurations

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [nixos-hardware](https://github.com/NixOS/nixos-hardware)
- [Catppuccin for Nix](https://github.com/catppuccin/nix)

## License

This configuration is provided as-is for reference and personal use. Feel free to use, modify, and learn from it.
