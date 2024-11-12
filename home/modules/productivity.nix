{ pkgs, ... }: 
{
	home.packages = with pkgs; [
		kdePackages.arianna
		obsidian
		libreoffice-qt6-fresh
	];
}
