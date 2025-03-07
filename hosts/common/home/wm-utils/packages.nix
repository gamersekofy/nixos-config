{pkgs, ... }: {
    home.packages = [
        pkgs.brightnessctl
        pkgs.wl-clipboard
        pkgs.playerctl

        pkgs.rofi-wayland
        pkgs.rofimoji

        pkgs.blueman
        pkgs.pavucontrol
    ];
}