{pkgs, ... }: {
    home.packages = with pkgs; [
        brightnessctl
        wl-clipboard
        playerctl

        rofi-wayland
        rofimoji

        blueman
        pavucontrol
        nautilus

	kdePackages.okular
	kdePackages.gwenview
    ];
}
